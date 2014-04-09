class ProfanityChecker
  PROFANITY_WORDS = %w(poop fart fartface poopface poopbuttface)

  def initialize(content)
    @content = content
  end

  # returns list of profanity words (empty list if none)
  def profanity_words_contained
    profanity_list = []
    words = @content.split(/\W/)
    PROFANITY_WORDS.each do |test_word|
      profanity_list << test_word if words.include?(test_word)
    end
    profanity_list
  end
end
