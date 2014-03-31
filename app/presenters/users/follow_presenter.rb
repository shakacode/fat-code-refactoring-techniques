class Users::FollowPresenter
  # Next line provides the 'h' as a proxy to the view context (access to helpers)
  include Draper::ViewHelpers
  attr_reader :type

  def initialize(type, user_id, page)
    @type = type
    @user_id = user_id
    @page = page
  end

  def title
    @type.to_s.titleize
  end

  def subtitle
    @subtitle ||= if @type == :following
        "You Are Following #{user.decorate.formatted_followed_count} Bloggers"
      else
        "Your Got #{user.decorate.formatted_followers_count} Followers"
      end
  end

  def user
    @user ||= User.find(@user_id)
  end

  def users
    @users ||= if @type == :following
                 user.followed_users.paginate(page: @page)
               else #followers
                 user.followers.paginate(page: @page)
               end
  end

  def microposts_count
    h.number_with_delimiter(user.microposts.count)
  end
end
