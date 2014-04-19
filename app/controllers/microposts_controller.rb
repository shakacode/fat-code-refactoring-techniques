class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = Micropost.new(micropost_params.merge(user: current_user))
    if current_user.minor? && (profane_words_used = profane_words_in(@micropost.content))
        current_user.increment(:profanity_count, profane_words_used.size)
        current_user.save(validate: false)
        send_parent_notifcation_of_profanity(profane_words_used)
        flash.now[:error] = <<-MSG.html_safe
          <p>Whoa, better watch your language! Profanity: '#{profane_words_used.join(", ")}' not allowed!
          You've tried to use profanity #{view_context.pluralize(current_user.profanity_count, "time")}!
          </p><p class="parent-notification">Your parents have been notified!</p>
        MSG
        render 'static_pages/home'
    else
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        render 'static_pages/home'
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    # return array of profane words in content or nil if none
    def profane_words_in(content)
      # PRETEND: Hit external REST API

      # NOTE: Implementation below is a simulation
      profane_words = %w(poop fart fartface poopface poopbuttface)
      content_words = content.split(/\W/)
      content_words.select { |word| word.in? profane_words }.presence
    end

    def send_parent_notifcation_of_profanity(profane_words)
      # PRETEND: send email
      Rails.logger.info("Sent profanity alert email to parent of #{current_user.name}, "\
          "who used profane words: #{profane_words}")
    end

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
