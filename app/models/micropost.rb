# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  validate :profanity_checker

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  # Will check for profanities if a user a minor, and if content OK, then save
  def save_checking_profanity
    if profanity_words_for_minor.present?
      user.minor_tried_to_use_profanities(profanity_words_for_minor)
      return false
    end
    save
  end

  def content=(content)
    @profanity_words_for_minor = nil
    self[:content] = content
  end

  # profanities only counted if user is a minor
  def profanity_words_for_minor
    @profanity_words_for_minor ||= if user.minor?
                           ProfanityChecker.new(content).profanity_words_contained
                         else
                           []
                         end
  end

  private
  def profanity_checker
    return unless user && user.minor?

    profanity_words = ProfanityChecker.new(content).profanity_words_contained
    errors.add(:content, "Profanity: '#{profanity_words.join(", ")}' not allowed!") if profanity_words.present?
  end
end
