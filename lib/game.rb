class Game
  attr_reader :word
  def initialize
    puts "Game initialized."
    @lines = File.readlines "5desk.txt"
    setup
  end

  def guess_letter
    puts "Guess a letter..."
    letter = gets.chomp
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
    while true
      guess_letter
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

  private
  def pick_random_word
    @word = @lines.sample
    pick_random_word unless @word.length > 5 && @word.length < 12
    @word
  end

  def setup
    @guesses = 6
    @word = pick_random_word
    @guessed = ""
    @word.each_char { |c| @guessed += "_"}
    @guessed[-1] = ''
  end

  def reset
    setup
  end
end

g = Game.new
g.play