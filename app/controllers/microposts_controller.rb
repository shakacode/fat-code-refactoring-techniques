class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    ok = true
    if current_user.minor?
      profanity_word =  profanity_word(@micropost.content)
      if profanity_word.present?
        flash.now[:error] = "You cannot create a micropost with profanity: '#{profanity_word}'!"
        current_user.increment(:profanity_count)
        @feed_items = []
        render 'static_pages/home'
        ok = false
      end
    end
    if ok
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private
    PROFANITY_WORDS = %w(poop fart fartface poopface poopbuttface)

    # Yes, this could go into a validator for the micropost, but let's suppose there's reasons
    # that we don't want to do that, such as we only want to filter profanity for posts
    # created by minors, etc.
    # returns profanity word if existing in content, or else nil
    def profanity_word(content)
      words = content.split(/\W/)
      PROFANITY_WORDS.each do |test_word|
        puts "test_word is #{test_word}, words is #{words}"
        return test_word if words.include?(test_word)
      end
      nil
    end

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
