describe MicropostCreationService do
  let(:minor) { FactoryGirl.create :user, minor: true, profanity_count: 0 }
  let(:adult) { FactoryGirl.create :user, minor: false, profanity_count: 0 }

  describe "#create_micropost" do
    let(:profanity_content) { "Dad is a poopface!" }
    context "minor" do
      context "does contain one word profanity" do
        subject(:service) { MicropostCreationService.new(minor, profanity_content) }
        it "returns a controller response" do
          response = service.create_micropost
          expect(response.flash_message).to match /poopface/
          expect(response.flash_type).to eq(:error)
          expect(response.ok).to be_false
          expect(minor.reload.profanity_count).to eq(1)
        end
      end

      context "does contain two word profanity" do
        subject(:service) { MicropostCreationService.new(minor, "Dad is a poop and poopbuttface") }
        it "returns a controller response" do
          response = service.create_micropost
          expect(response.flash_message).to match /poopbuttface/
          expect(response.flash_type).to eq(:error)
          expect(response.ok).to be_false
          expect(minor.reload.profanity_count).to eq(2)
        end
      end

      context "adult" do
        subject(:service) { MicropostCreationService.new(adult, profanity_content) }
        context "does contain profanity" do
          it "returns a controller response" do
            response = service.create_micropost
            expect(response.flash_message).to eq("Micropost created!")
            expect(response.flash_type).to eq(:success)
            expect(response.redirect_path).to_not be_nil
            expect(response.ok).to be_true
            expect(adult.profanity_count).to eq(0)
          end
        end
      end

      context "content does not contain profanity" do
        subject(:service) { MicropostCreationService.new(minor, "Dad is the best!") }

        describe "#create" do
          it "returns a controller response" do
            response = service.create_micropost
            expect(response.flash_message).to eq("Micropost created!")
            expect(response.flash_type).to eq(:success)
            expect(response.redirect_path).to_not be_nil
            expect(response.ok).to be_true
            expect(minor.profanity_count).to eq(0)
          end
        end
      end
    end
  end
end
