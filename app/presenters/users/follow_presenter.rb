module Users
  class FollowPresenter
    include Draper::ViewHelpers

    def initialize(type, user_id, page)
      @type    = type
      @user_id = user_id
      @page    = page
    end

    def title
      @type.to_s.titleize
    end

    def user
      @user ||= User.find(@user_id)
    end

    def users
      @users ||= if @type == :following
                  user.followed_users.paginate(page: @page)
                else
                  user.followers.paginate(page: @page)
                end
    end

    def subtitle
      @subtitle ||= if @type == :following
                      "You Are Following #{h.pluralize(user.followed_users.size, "Bloggers")}"
                    else
                      "Your Got #{h.pluralize(user.followers.size, "Followers")}"
                    end
    end

    def cache_key
      [user, title]
    end
  end
end
