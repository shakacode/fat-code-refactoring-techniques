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

  # return response if content has profanity words and adds the number of profanity words to the
  # user's profanity counter
  def check_profanity(micropost)
    return nil unless @user.minor?

    if has_profanity?
      @user.increment(:profanity_count, profanity_words.size)
      @user.save!(validate: false) # validation false b/c of password min length

      msg = <<-MSG
        Whoa, better watch your language! Profanity: '#{profanity_words.join(", ")}' not allowed!
        You've tried to use profanity #{h.pluralize(@user.profanity_count, "time")}!
      MSG
      ControllerResponse.new(flash_message: msg,
                             flash_type:    :error,
                             flash_now:     true,
                             http_status:   :bad_request,
                             data:          { micropost: micropost })
    end
  end

  def has_profanity?
    profanity_words.present?
  end

  # Yes, this could go into a validator for the micropost, but let's suppose there's reasons
  # that we don't want to do that, such as we want a special flash message.
  # returns profanity words if existing in content, or else nil
  def profanity_words
    # Important not to memorize nil or false
    @profanity_words ||= ProfanityChecker.new(@content).profanity_words_contained
  end
end
