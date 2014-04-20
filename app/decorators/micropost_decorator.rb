class MicropostDecorator < Draper::Decorator

  def posted_ago
    h.content_tag :span, class: 'timestamp' do
      "Posted #{h.time_ago_in_words(object.created_at)} ago."
    end
  end
end
