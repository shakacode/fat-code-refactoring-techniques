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
  validate :no_profanity

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  # return array of profane words in content or nil if none
  def profane_words_in_content
    # PRETEND: Hit external REST API

    # NOTE: Implementation below is a simulation
    profane_words = %w(poop fart fartface poopface poopbuttface)
    content_words = content.split(/\W/)
    content_words.select { |word| word.in? profane_words }.presence
  end

  # This could have been done with and after_save hook, but it seems wrong to ever be sending
  # emails from after_save.
  # Return true if save successful
  def save_with_profanity_callbacks
    transaction do
      valid = save
      if profanity_validation_error?
        profane_words_used = profane_words_in_content
        user.increment(:profanity_count, profane_words_used.size)
        user.save(validate: false)
        user.send_parent_notification_of_profanity(profane_words_used)
      end
      valid
    end
  end

  def profanity_validation_error?
    errors[:content].find { |error| error =~ /\AProfanity:/ }
  end

  private

    def no_profanity
      if user && user.minor? && (profane_words = profane_words_in_content)
        errors.add(:content, "Profanity: #{profane_words.join(", ")} not allowed!")
      end
    end
end
