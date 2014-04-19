module Users
  class FollowPresenter
    include Draper::ViewHelpers

    def initialize(user_id, page)
      @user_id = user_id
      @page    = page
    end

    def user
      @user ||= User.find(@user_id)
    end

    def cache_key
      [user, title]
    end
  end
end
