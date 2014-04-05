require 'spec_helper'

describe UserDecorator do
  describe "#formatted_followed_count" do
    before do
      @user = FactoryGirl.create(:user)
      1000.times do
        other_user = FactoryGirl.create(:user)
        @user.follow!(other_user)
        other_user.follow!(@user)
      end
    end

    # xit this b/c too slow right now
    xit "returns a number with a comma" do
      expect(@user.decorate.formatted_followed_count).to eq("1,000")
      expect(@user.decorate.formatted_followers_count).to eq("1,000")
    end
  end
end
