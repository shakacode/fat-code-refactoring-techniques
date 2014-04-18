class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = Micropost.new(micropost_params.merge(user: current_user))
    if @micropost.save_with_profanity_callbacks
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      if @micropost.profanity_validation_error?
        @micropost.errors[:content].clear # remove the default validation message
        flash.now[:error] = <<-MSG.html_safe
          <p>Whoa, better watch your language! Profanity: '#{@micropost.profane_words_in_content.join(", ")}' not allowed!
          You've tried to use profanity #{view_context.pluralize(current_user.profanity_count, "time")}!
          </p><p class="parent-notification">Your parents have been notified!</p>
        MSG
      end
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
