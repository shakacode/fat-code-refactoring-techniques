module Users
  class FollowersController < ApplicationController
    before_action :signed_in_user

    def followers
      @presenter = Users::FollowersPresenter.new(params[:id], params[:page])
      render '/users/show_follow'
    end
  end
end
