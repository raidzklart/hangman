require 'json'

class Game
  attr_reader :word
  def initialize
    puts "Game initialized."
    @lines = File.readlines "5desk.txt"
    setup
  end

  def guess_letter(letter)
    correct = false
    @guesses -= 1
    @word.each_char.with_index do |c, i| 
      if letter.downcase == c.downcase
        @guessed[i] = letter
        correct = true
      end
    end
    @guesses += 1 if correct
    puts  "You have #{@guesses} guesses remaining..."
    puts "So far you have guessed #{@guessed}"
  end

  def play
    puts "You may load a previous game by typing: !l :id"
    puts "You may also save the game at any time by typing: !s"
    while true
      puts "Guess a letter..."
      letter = gets.chomp
      if letter.length > 1
        if letter == "!s"
          save_game
          @guesses += 1
        end
        if letter.include? "!l"
          id = letter.split(" ")[1]
          load_game(id)
          @guesses += 1
        end
      else
        guess_letter(letter)
      end
      if @guesses < 1
        puts "Unlucky, you didn't guess the word. It was: #{@word}"
        break
      elsif @word.downcase.chomp == @guessed.downcase.chomp
        puts "Well done, you got it!"
        break
      end
    end
    puts "Would you like to play again? [Y/N]"
    answer = gets.chomp
    if answer[0].upcase == "Y"
      setup
      self.play
    elsif answer[0].upcase == "N"
      exit!
    else
      puts "You didn't choose Y or N, game will now exit."
      exit!
    end
  end

  def to_json
    JSON.dump ({
      :word => @word,
      :guessed => @guessed,
      :guesses => @guesses
    })
  end

  private
  def pick_random_word
    @word = @lines.sample
    pick_random_word unless @word.length > 5 && @word.length < 12
    @word
  end

  def save_game
    Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
    id = Dir[File.join("saved_games", '**', '*')].count { |file| File.file?(file) }
    filename = "saved_games/#{id}.json"

    File.open(filename,'w') do |file|
      file.puts self.to_json
    end
    exit!
  end

  def load_game(id)
    path_to_file = "saved_games/#{id}.json"
    file = JSON.load File.read (path_to_file)
    puts file
    @word = file["word"]
    @guessed = file['guessed']
    @guesses = file['guesses']
    File.delete(path_to_file) if File.exist?(path_to_file)
  end

  def setup
    @guesses = 6
    @word = pick_random_word.chomp
    @guessed = ""
    @word.each_char { |c| @guessed += "_"}
  end

  def reset
    setup
  end
end

g = Game.new
g.play