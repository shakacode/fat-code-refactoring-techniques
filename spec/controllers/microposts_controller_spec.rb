require 'spec_helper'
describe MicropostsController do
  let(:minor) { FactoryGirl.create :user, minor: true, profanity_count: 0 }
  let(:adult) { FactoryGirl.create :user, minor: false, profanity_count: 0 }
  let(:profanity_content) { "Dad is a poopface and fartface!" }
  let(:clean_content) { "Dad is the best!" }

  def flash_now
    flash.instance_variable_get(:@now)
  end

  context "does contain two word profanity" do
    subject(:service) { MicropostCreationService.new(minor, profanity_content) }
    context "a minor" do
      before { sign_in minor, no_capybara: true }

      it "gives a flash with poopface and fartface" do
        pending "Fix flash message for minor saving profanity"
        post :create, micropost: { content: profanity_content }

        # Demonstrate testing flash.now
        expect(flash_now[:error]).to match /poopface/
        expect(flash_now[:error]).to match /fartface/
        expect(flash_now[:error]).to match /2 times/

        # Demonstrate checking rendered template
        expect(response).to render_template('static_pages/home')

        # Demonstrate checking instance variable
        expect(assigns(:micropost).content).to eq(profanity_content)

        expect(response.status).to eq(200)
      end

      it "increases the minor's profanity count by 2" do
        expect do
          post :create, micropost: { content: profanity_content }
        end.to change { minor.reload.profanity_count }.by(2)
      end

      it "does not increase the number of posts" do
        expect do
          post :create, micropost: { content: profanity_content }
        end.not_to change { Micropost.count }
      end
    end

    context "adult" do
      before { sign_in adult, no_capybara: true }

      it "gives a flash with poopface and fartface" do
        post :create, micropost: { content: profanity_content }
        expect(flash[:success]).to eq("Micropost created!")
        expect(response).to redirect_to(root_url)
      end

      it "does not change the profanity count" do
        expect do
          post :create, micropost: { content: profanity_content }
        end.not_to change { adult.reload.profanity_count }
      end

      it "does increase the number of posts" do
        expect do
          post :create, micropost: { content: profanity_content }
        end.to change { Micropost.count }.by(1)
      end
    end
  end
  context "no profanity" do
    context "minor" do
      before { sign_in minor, no_capybara: true }

      it "gives a flash with poopface and fartface" do
        post :create, micropost: { content: clean_content }
        expect(flash[:success]).to eq("Micropost created!")
        expect(response).to redirect_to(root_url)
      end

      it "does not change the profanity count" do
        expect do
          post :create, micropost: { content: clean_content }
        end.not_to change { minor.reload.profanity_count }
      end

      it "does increase the number of posts" do
        expect do
          post :create, micropost: { content: clean_content }
        end.to change { Micropost.count }.by(1)
      end
    end
  end
end
