module Users
  class FollowersController < ApplicationController
    include SignedInUser

    def followers
      @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
      render '/users/show_follow'
    end
  end
end
