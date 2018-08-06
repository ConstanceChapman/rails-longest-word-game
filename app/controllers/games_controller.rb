require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    random_sample = ("A".."Z").to_a.shuffle
    multiple_sample = random_sample * 2
    @letters = multiple_sample.sample(10)
  end

  def check_validity(arr1, arr2)
    arr1_hash = {}
    arr2_hash = {}
    arr1.each { |letter| arr1_hash[letter] ? arr1_hash[letter] += 1 : arr1_hash[letter] = 1 }
    arr2.each { |letter| arr2_hash[letter] ? arr2_hash[letter] += 1 : arr2_hash[letter] = 1 }
    arr1_hash.each do |key, _value|
      return false if arr1_hash[key].to_i > arr2_hash[key].to_i
    end
  end

  def write_message(word, letters, checker)
    if checker["found"] == false
      return "Sorry but #{word} is not a valid English word."
    elsif letters.include?(word)
      return "Sorry but #{word} cannot be made from #{letters.join(" ")}"
    else
      return "Sorry but #{word} cannot be made from #{letters.join(" ")}"
    end
  end

  def score
    attempt = params[:word]
    grid = params[:grid].split("")
    result = {attempt: attempt}
    word_checker = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt.downcase}").read)
    attempt_arr = attempt.upcase.split("")
    if word_checker["found"] && attempt_arr.all? { |letter| grid.include? letter } && check_validity(attempt_arr, grid)
      result[:message] = "Congratulations! #{attempt.capitalize} is a valid English word."
    else
      result[:message] = write_message(attempt, grid, word_checker)
    end
    @message = result[:message]
  end
end
