module Users
  class FollowersPresenter < FollowPresenter
    def users
      @users ||= user.followers.paginate(page: @page)
    end

    def title
      "Followers"
    end

    def subtitle
      @subtitle ||= "Your Got #{user.followers.size} Followers"
    end
  end
end

