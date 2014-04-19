module Users
  class FollowingController < ApplicationController
    include SignedInUser

    def following
      @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
      render '/users/show_follow'
    end
  end
end
