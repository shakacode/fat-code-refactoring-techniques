class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = Micropost.new(micropost_params.merge(user: current_user))
    ok = true
    if current_user.minor?
      profanity_words =  profanity_words(@micropost.content)
      if profanity_words.present?
        flash.now[:error] = "You cannot create a micropost with profanity: '#{profanity_words.join(", ")}'!"
        current_user.increment(:profanity_count)
        current_user.save(validate: false)
        send_parent_notifcation_of_profanity(profanity_words)
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
    def profanity_words(content)
      profanity_list = []
      words = content.split(/\W/)
      PROFANITY_WORDS.each do |test_word|
        profanity_list << test_word if words.include?(test_word)
      end
      profanity_list
    end

    def send_parent_notifcation_of_profanity(profanity_words)
      # send email
    end

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
