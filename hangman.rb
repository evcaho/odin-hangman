require 'sinatra'
require 'erb'
require './word_generator'

enable :sessions

def store_name(filename, string)
	File.open(filename, "a+") do |file|
		file.puts(string)
	end
end

def empty_file(filename)
	File.open(filename, "w")
end

def read_names(filename)
	return [] unless File.exist?(filename)
	File.read(filename).split("\n")
end

def win(word, correct_letters)
  if (word.split("") - correct_letters).empty?
    return true
  end
end

def hide_word(word, guessed_letters)
  hidden_word = []
  word_array = word.split("")
  word_array.each do |letter|
    if guessed_letters.include?(letter)
      hidden_word.push(letter)
    else
      hidden_word.push("_")
    end
  end
  hide = hidden_word.join("")
  hide.gsub(/.{1}(?=.)/, '\0 ')

end

def check_includes(word, letter)
  character_array = word.split("")
  if character_array.include?(letter)
    return true
  end
end

class LetterValidator
	def initialize(letter, letters)
    @letter = letter.to_s
    @letters = letters
  end

  def valid?
    validate
    @message.nil?
  end

  def message
    @message
  end

  private

    def validate
      if @letter.empty?
        @message = "You need to enter a letter."
      elsif @letters.include?(@letter)
        @message = "#{@letter} is already included in our list."
      end
    end
end

get "/" do
 	if !session[:word]
 		hangman = Hangmanword.new()
 		session[:word] = hangman.secret_word.downcase
 		session[:guesses] = 10
 		empty_file("names.txt")
    empty_file("correct.txt")
 	end
 	@word = session[:word]
 	@guesses = session[:guesses]
 	@letter = params["letter"]
  @correct_letters = read_names("correct.txt")
 	@letters = read_names("names.txt")
  @hidden_word = hide_word(@word, @correct_letters)
 	erb :index
end

post "/" do
	@letter = params[:letter].downcase
	@letters = read_names("names.txt")
  @correct_letters = read_names("correct.txt")
	@word = session[:word]
	validator = LetterValidator.new(@letter, @letters)

	if validator.valid?
   		store_name("names.txt", @letter)
      if check_includes(@word, @letter)
        store_name("correct.txt", @letter)
      end
    	session[:guesses] = session[:guesses] - 1
    	@guesses = session[:guesses]
      @correct_letters = read_names("correct.txt")
      @letters = read_names("names.txt")
    	@message = "Successfully stored the letter #{@letter}."
      @hidden_word = hide_word(@word, @correct_letters)
    	if @guesses == 0 
    		redirect to "/lose"
    	end
      if win(@word, @correct_letters)
          old_word = session[:word]
          redirect to "/win"
      end
  	else
    	@message = validator.message

  end

	erb :index
end


get "/lose" do
	session[:word] = nil
	erb :lose
end

get "/win" do
  @old_word
  session[:word] = nil
  erb :win
end
