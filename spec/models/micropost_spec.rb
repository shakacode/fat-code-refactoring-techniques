# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end

describe "profanity checking" do
  let(:profane_content) { "Dad is a poopface and fartface!" }
  let(:clean_content) { "Dad is the best!" }
  let(:minor) { FactoryGirl.create :user, minor: true }
  let(:adult) { FactoryGirl.create :user, minor: false }
  context "user is a minor" do
    context "with profanity" do
      before { @micropost = Micropost.new(content: profane_content, user: minor) }
      it "returns false" do
        expect(@micropost).not_to be_valid
      end
      it "has validation error for content" do
        @micropost.save
        content_errors = @micropost.errors[:content][0]
        expect(content_errors).to match /poopface/
        expect(content_errors).to match /fartface/
      end
    end
    context "without profanity" do
      it "is valid" do
        micropost = Micropost.new(content: clean_content, user: minor)
        expect(micropost).to be_valid
      end
    end
  end
  context "user is an adult" do
    context "with profanity" do
      it "is valid" do
        micropost = Micropost.new(content: profane_content, user: adult)
        expect(micropost).to be_valid
      end
    end
    context "without profanity" do
      it "is valid" do
        micropost = Micropost.new(content: clean_content, user: adult)
        expect(micropost).to be_valid
      end
    end
  end
end

describe "Micropost#save_with_profanity_callbacks" do
  let(:profanity_content) { "Dad is a poopface and fartface!" }
  let(:clean_content) { "Dad is the best!" }
  let(:minor) { FactoryGirl.create :user, minor: true, profanity_count: 0 }
  let(:adult) { FactoryGirl.create :user, minor: false }

  context "user is a minor" do
    context "with profanity" do
      before { @micropost = Micropost.new(content: profanity_content, user: minor) }
      it "returns false" do
        expect(@micropost.save_with_profanity_callbacks).to be_false
      end

      it "has profanity validation errors" do
        @micropost.save_with_profanity_callbacks
        expect(@micropost.profanity_validation_error?).to be_true
        expect(@micropost).not_to be_persisted
      end

      it "has profanity updated the user's profanity count" do
        @micropost.save_with_profanity_callbacks
        expect(@micropost.user.profanity_count).to eq(2)
        expect(@micropost.user).to be_persisted
      end
    end

    context "without profanity" do
      before { @micropost = Micropost.new(content: clean_content, user: minor) }

      it "returns true" do
        expect(@micropost.save_with_profanity_callbacks).to be_true
      end

      it "returns saves the @micropost" do
        @micropost.save_with_profanity_callbacks
        expect(@micropost).to be_persisted
        expect(@micropost.user.profanity_count).to eq(0)
      end
    end
  end

  context "user is an adult" do
    context "with profanity" do
      before { @micropost = Micropost.new(content: profanity_content, user: adult) }

      it "returns true" do
        expect(@micropost.save_with_profanity_callbacks).to be_true
      end

      it "returns saves the @micropost" do
        @micropost.save_with_profanity_callbacks
        expect(@micropost).to be_persisted
      end
    end
  end
end

