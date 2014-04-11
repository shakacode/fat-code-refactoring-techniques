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

describe "Micropost#create_with_profanity_checks" do
  let(:profanity_content) { "Dad is a poopface and fartface!" }
  let(:clean_content) { "Dad is the best!" }
  let(:minor) { FactoryGirl.create :user, minor: true }
  let(:adult) { FactoryGirl.create :user, minor: false }

  context "user is a minor" do
    context "with profanity" do
      before { @micropost = Micropost.new(content: profanity_content, user: minor) }
      it "returns false" do
        expect(@micropost.save_checking_profanity).to be_false
      end
      it "called user.minor_tried_to_use_profanities" do
        # We'll test what user#minor_tried_to_use_profanities in the user_spec.rb
        allow(@micropost.user).to receive(:minor_tried_to_use_profanities).and_return(nil)
        @micropost.save_checking_profanity
        expect(@micropost.user).to have_received(:minor_tried_to_use_profanities)
      end
    end
    context "without profanity" do
      before { @micropost = Micropost.new(content: clean_content, user: minor) }
      it "returns true" do
        expect(@micropost.save_checking_profanity).to be_true
      end
      it "returns saves the @micropost" do
        @micropost.save_checking_profanity
        expect(@micropost).to be_persisted
      end
    end
  end

  context "user is an adult" do
    context "with profanity" do
      before { @micropost = Micropost.new(content: profanity_content, user: adult) }
      it "returns true" do
        expect(@micropost.save_checking_profanity).to be_true
      end
      it "returns saves the @micropost" do
        @micropost.save_checking_profanity
        expect(@micropost).to be_persisted
      end
    end
  end
end

