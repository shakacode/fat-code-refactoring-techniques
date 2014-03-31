class UserDecorator < Draper::Decorator
  delegate_all

  def formatted_followed_count
    @followed_count ||= begin
      h.number_with_delimiter(followed_users.count)
    end
  end

  def formatted_followers_count
    @followers_count ||= begin
      h.number_with_delimiter(followers.count)
    end
  end
end
