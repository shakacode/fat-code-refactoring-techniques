describe MicropostCreationService do
  let(:minor) { FactoryGirl.create :user, minor: true }
  let(:adult) { FactoryGirl.create :user, minor: false }

  describe "#profanity_word" do
    let(:profanity_content) { "Dad is a poopface!" }
    context "minor" do
      subject(:service) { MicropostCreationService.new(minor, profanity_content) }
      context "does contain profanity" do
        describe "#profanity_word" do
          it "returns poopface" do
            expect(service.profanity_word).to eq("poopface")
          end
        end

        describe "#create" do
          it "returns a controller response" do
            response = service.create_micropost
            expect(response.flash_message).to match /poopface/
            expect(response.flash_type).to eq(:error)
            expect(response.ok).to be_false
          end
        end
      end

      context "adult" do
        subject(:service) { MicropostCreationService.new(adult, profanity_content) }
        context "does contain profanity" do
          describe "#profanity_word" do
            it "returns nil" do
              expect(service.profanity_word).to be_nil
            end
          end

          describe "#create" do
            it "returns a controller response" do
              response = service.create_micropost
              expect(response.flash_message).to eq("Micropost created!")
              expect(response.flash_type).to eq(:success)
              expect(response.redirect_path).to_not be_nil
              expect(response.ok).to be_true
            end
          end
        end
      end

      context "content does not contain profanity" do
        subject(:service) { MicropostCreationService.new(minor, "Dad is the best!") }

        describe "#profanity_word" do
          it "returns nil" do
            expect(service.profanity_word).to be_nil
          end
        end

        describe "#create" do
          it "returns a controller response" do
            response = service.create_micropost
            expect(response.flash_message).to eq("Micropost created!")
            expect(response.flash_type).to eq(:success)
            expect(response.redirect_path).to_not be_nil
            expect(response.ok).to be_true
          end
        end
      end
    end
  end
end
