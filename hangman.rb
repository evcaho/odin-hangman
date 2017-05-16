require 'sinatra'
require 'erb'
require './word_generator'

enable :sessions

def store_name(filename, string)
	File.open(filename, "a+") do |file|
		file.puts(string)
	end
end

def read_names
	return [] unless File.exist?("names.txt")
	File.read("names.txt").split("\n")
end

get "/" do
 	if !session[:word]
 		hangman = Hangmanword.new()
 		session[:word] = hangman.secret_word
 		session[:guesses] = 10
 		@guesses = session[:guesses]
 	end
 	@word = session[:word]
 	@guesses = session[:guesses]
 	@letter = params["letter"]
 	@letters = read_names
 	erb :index
end

post "/" do
	@letter = params[:letter].downcase
	@word = session[:word]
	@guesses = session[:guesses]
	store_name("names.txt", @letter)
	@letters = read_names
#	session[:guessed_letters] = []
#	@guessed = session[:guessed_letters]
#	@input_array = letter_array(letter)
	erb :index
end
