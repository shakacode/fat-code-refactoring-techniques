class MicropostCreateController < ApplicationController
  before_action :signed_in_user

  # By having one public method, all private methods relate to this one method
  # and any instance variables can apply to all private methods
  def create
    @micropost = Micropost.new(micropost_params.merge(user: current_user))
    return if current_user.minor? && used_profanity
    save_micropost
  end

  private

    def save_micropost
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        error_rendering
      end
    end


    # return true if checked to ensure no profanity violations
    def used_profanity
      if profanity_words.present?
        profanity_found_side_effects
        profanity_found_controller_response
      end
    end

    def profanity_words
      @profanity_words ||= ProfanityChecker.new(@micropost.content).profanity_words_contained
    end

    def profanity_found_controller_response
      flash.now[:error] = <<-MSG
            Whoa, better watch your language! Profanity: '#{profanity_words.join(", ")}' not allowed!
            You've tried to use profanity #{view_context.pluralize(current_user.profanity_count, "time")}!
      MSG
      error_rendering
      true
    end

    def error_rendering
      @feed_items = []
      render 'static_pages/home'
    end

    def profanity_found_side_effects
      current_user.increment(:profanity_count, profanity_words.size)
      current_user.save(validate: false)
      send_parent_notifcation_of_profanity
    end

    def send_parent_notifcation_of_profanity
      # pretend we sent an email, using @profanity_words in the content
    end

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
