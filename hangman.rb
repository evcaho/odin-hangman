require 'sinatra'
require 'erb'
require './word_generator'

enable :sessions

get "/" do
 	if !session[:word]
 		hangman = Hangmanword.new()
 		session[:word] = hangman.secret_word
 		session[:guesses] = 10
 	end
 	@word = session[:word]
 	@guesses = session[:guesses]
 	erb :index
end

post "/" do
	letter = params[:letter].downcase
	if session[:guesses] > 1
		session[:guesses] - 1
	end
end
