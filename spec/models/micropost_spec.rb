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

describe "Micropost with profanity" do
  describe "with content that contains profanity" do
    it "is not valid for minor" do
      minor = FactoryGirl.create(:user, minor: true)
      micropost = Micropost.new(content: "Lorem ipsum poop", user: minor)
      expect(micropost).not_to be_valid
    end

    it "is not valid for non-minor" do
      minor = FactoryGirl.create(:user, minor: false)
      micropost = Micropost.new(content: "Lorem ipsum poop", user: minor)
      expect(micropost).to be_valid
    end
  end
end
