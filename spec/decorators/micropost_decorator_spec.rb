require 'spec_helper'

describe MicropostDecorator do

  describe "posted_ago" do
    let(:user) { FactoryGirl.create(:user) }
    it "prints time ago in words" do
      micropost = Micropost.create(content: "Lorem ipsum", user_id: user.id)
      expect(micropost.decorate.posted_ago).to match /Posted less than a minute ago./
    end
  end

  describe "profanity_violation_msg" do
    let(:user) { FactoryGirl.create(:user, profanity_count: 20) }
    it "creates a message" do
      micropost               = Micropost.create(content: "Lorem poopface, fartface", user_id: user.id)
      profanity_violation_msg = micropost.decorate.profanity_violation_msg
      expect(profanity_violation_msg).to match /poopface/
      expect(profanity_violation_msg).to match /fartface/
      expect(profanity_violation_msg).to match /20 times/
      expect(profanity_violation_msg).to match /Your parents have been notified!/
    end
  end
end
