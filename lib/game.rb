puts "Hangman initialized."

lines = File.readlines "5desk.txt"

def pick_random_word(lines)
  word = lines.sample
  pick_random_word(lines) unless word.length > 5 && word.length < 12
  word
end

puts pick_random_word(lines)