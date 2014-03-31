module User::FinderMethods
  extend ActiveSupport::Concern

  included do
    # downcase the searched for email
    scope :by_email_wildcard, ->(q) { where("email like ?", "#{q.downcase}%") }
  end

  module ClassMethods
    # Note, removed "self.method_name" when converting to Module
    def by_email(email)
      where(email: email.downcase).first
    end

    # Other finder methods
  end
end
