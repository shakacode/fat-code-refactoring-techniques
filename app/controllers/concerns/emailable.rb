module Emailable
  extend ActiveSupport::Concern

  included do
    before_save { self.email = email.downcase }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
              uniqueness:       { case_sensitive: false }

    # downcase the searched for email
    scope :by_email_wildcard, ->(q) { where("email like ?", "#{q.downcase}%") }
  end

  def email_domain
    regex = /\A[\w+\-.]+@([a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z)/i
    email[regex, 1]
  end

  module ClassMethods
    def by_email(email)
      where(email: email.downcase).first
    end
  end
end
