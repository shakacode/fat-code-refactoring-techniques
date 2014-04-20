module Users
  class FollowingController < ApplicationController
    before_action :signed_in_user

    def following
      @presenter = Users::FollowedUsersPresenter.new(params[:id], params[:page])
      render '/users/show_follow'
    end
  end
end
