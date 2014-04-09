describe ProfanityChecker do
  describe "#profanity_words" do
    subject(:service) { ProfanityChecker.new(profanity_content) }
    context "no profanity words" do
      let(:profanity_content) { "Dad is the best!" }
      its(:profanity_words_contained) { should be_empty }
    end

    context "one profanity word" do
      let(:profanity_content) { "Dad is a poopface!" }
      its(:profanity_words_contained) { should match_array(["poopface"]) }
    end

    context "two profanity words" do
      let(:profanity_content) { "Dad is a poopface and fartface!" }
      its(:profanity_words_contained) { should match_array(["poopface", "fartface"]) }
    end
  end
end
