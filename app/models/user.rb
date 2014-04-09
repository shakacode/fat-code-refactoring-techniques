# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  profanity_count :integer          default(0)
#  minor           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  include User::FinderMethods

  # Methods concerning feed from other users
  include User::FeedMethods

  # These are my posts
  has_many :microposts, dependent: :destroy

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Actions to take if minor tries to use profanities
  # profanities List of words attempted to use
  def minor_tried_to_use_profanities(profanity_words)
    raise "Called minor_tried_to_use_profanities with adult" unless minor?
    increment(:profanity_count, profanity_words.size)
    save(validate: false)
    send_parent_notifcation_of_profanity
  end

  private
    def send_parent_notifcation_of_profanity
      # pretend we sent an email, using @profanity_words in the content
    end


  def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
