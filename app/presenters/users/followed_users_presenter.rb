module Users
  class FollowedUsersPresenter < FollowPresenter
    def users
      @users ||= user.followed_users.paginate(page: @page)
    end

    def title
      "Following"
    end

    def subtitle
      @subtitle ||= "You Are Following #{h.pluralize(user.followed_users.size, "Blogger")}"
    end
  end
end
