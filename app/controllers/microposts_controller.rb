class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = Micropost.new(micropost_params.merge(user: current_user))
    if @micropost.save_checking_profanity
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      set_flash_for_profanities
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
    # Example of customized flash message when the standard validation is not sufficient
    def set_flash_for_profanities
      if @micropost.profanity_words_for_minor.present?
        flash.now[:error] = <<-MSG
                Whoa, better watch your language! Profanity: '#{@micropost.profanity_words_for_minor.join(", ")}' not allowed!
                You've tried to use profanity #{view_context.pluralize(current_user.profanity_count, "time")}!
        MSG
      end
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
