require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters.push(('A'..'Z').to_a.sample)
    end
  end

  def english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def correctness(new_word)
    if new_word.length > 11
      "word's too long"
    elsif new_word.length == 10
      'you found the longest word possible!'
    else
      "your word count for #{new_word.length} points !"
    end
  end

  def score
    @letters = params[:letters].downcase
    new_word = params[:try].downcase
    if new_word.chars.all? { |letter| new_word.count(letter) <= @letters.split(" ").count(letter)}
      if english_word(new_word)
         @comment = correctness(new_word)
      else
        @comment = "#{new_word} isn't english"
      end
    else
      @comment = "#{new_word} doesn't fit the grid requirements"
    end
    @letters = params[:letters]
  end
end
