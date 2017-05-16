 class Hangmanword
	 def initialize
		@array = make_array
	end

	def make_array
		File.readlines('5desk.txt').map do |line|
			line.chomp
		end
	end

	def valid_words
		hangman_words = []
		make_array.each do |word|
			if word.length.between?(5,12) 
				hangman_words.push(word)
			end
		end
		hangman_words
	end

	def secret_word
		valid_words.sample
	end
end
