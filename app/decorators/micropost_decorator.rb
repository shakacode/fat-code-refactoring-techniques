class MicropostDecorator < Draper::Decorator

  def posted_ago
    h.content_tag :span, class: 'timestamp' do
      "Posted #{h.time_ago_in_words(object.created_at)} ago."
    end
  end

  def profanity_violation_msg
    <<-MSG.html_safe
      <p>Whoa, better watch your language! Profanity: '#{object.profane_words_in_content.join(", ")}' not allowed!
      You've tried to use profanity #{h.pluralize(object.user.profanity_count, "time")}!
      </p><p class="parent-notification">Your parents have been notified!</p>
    MSG
  end
end
