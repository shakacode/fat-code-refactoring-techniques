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

  PROFANITY_WORDS = %w(poop fart fartface poopface poopbuttface)
  validate :profanity_checker

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def profanity_checker
    return unless user && user.minor?

    profanity_words = ProfanityChecker.new(content).profanity_words_contained
    errors.add(:content, "Profanity: '#{profanity_words.join(", ")}' not allowed!") if profanity_words.present?
  end
end
