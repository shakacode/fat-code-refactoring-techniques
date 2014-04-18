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
