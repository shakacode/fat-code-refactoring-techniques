class MicropostCreationService
  # only to access the URL helper
  include Draper::ViewHelpers

  def initialize(user, content)
    @user    = user
    @content = content
  end

  def create_micropost
    micropost = @user.microposts.build(content: @content)
    response  = check_profanity(micropost)
    unless response
      response = save_micropost(micropost)
    end
    response
  end

  def save_micropost(micropost)
    if micropost.save
      ControllerResponse.new(flash_message: "Micropost created!",
                             flash_type:    :success,
                             redirect_path: h.root_url)
    else
      ControllerResponse.new(http_status: :bad_request, data: { micropost: micropost })
    end
  end


  # return response or
  def check_profanity(micropost)
    if profanity_word
      msg = "Whoa, better watch your language! Profanity: '#{profanity_word}' not allowed!"
      @user.increment(:profanity_count)
      ControllerResponse.new(flash_message: msg,
                             flash_type:    :error,
                             flash_now:     true, # True b/c not redirecting
                             http_status:   :bad_request,
                             data:          { micropost: micropost })
    end
  end

  PROFANITY_WORDS = %w(poop fart fartface poopface)

  def profanity_word
    @profanity_word ||= find_profanity_word
  end

  # Yes, this could go into a validator for the micropost, but let's suppose there's reasons
  # that we don't want to do that, such as we only want to filter profanity for posts
  # created by minors, etc.
  # returns profanity word if existing in content, or else nil
  def find_profanity_word
    return nil unless @user.minor?

    words = @content.split(/\W/)
    PROFANITY_WORDS.each do |test_word|
      return test_word if words.include?(test_word)
    end
    nil
  end
end
