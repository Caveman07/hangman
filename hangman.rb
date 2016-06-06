
require 'yaml'

class Hangman

@@words = File.read("5desk.txt").split

puts "#{@@words.length} of words loaded"
@@letters = ('a'..'z').to_a
@@passedletters = []

def random_word
	downcasedarray = @@words.map {|word| word.downcase} 
	rangedarray = downcasedarray.select {|word| word.length.between?(5, 12) }
    @hidden_word = rangedarray.sample(1)[0].to_s
	return @hidden_word
end

def start
    puts ">>>"
    puts "Welcome to the game, Hangman!"
    hiddenword = random_word
    # puts hiddenword
    puts "I am thinking of a word that is #{hiddenword.length} letters long"
    #here it shows the letter in a hidden form
    show_gueesed_letters(hiddenword)
    acceptingletters(hiddenword)


end

def show_gueesed_letters(someword) #if a letter is guess it prints all gueesed letters from a word
		#it scans through the hiddenword letters and if a letter matches the one from the passed letters then it prints it
		#else it prints "_"
		@show = []
		someword.split("").each do |letter|
			if @@passedletters.include?(letter)
				@show.push(letter)
			else
				@show.push("_")
			end
		end
		puts @show.join("")
	end

def acceptingletters(hiddenword)
	#we need to ask a player to choose letter
	#it can only used once and can only be a letter with length 1 
	#if letter is in the @@letters
	#if we accept it we check if its in the hiddenword 
	#if yes >> we print you gueessed then we push it to the @@passedletters and remove from @@letters
	#if not >> u missed and gueessleft - 1
	availableguess = 12
	gameover = false

	while availableguess > 0 && gameover == false

	puts "You have #{availableguess} guesses left"
	puts "Choose any available letter from #{@@letters.join(",")} or save the game by typing 'save'"
	guess = gets.chomp.downcase
	x = hiddenword.split("")
	if guess.length == 1 && guess.class == String
		if @@letters.include?(guess[0])
			#check if its in the hidden word
			if x.include?(guess)
				@@passedletters.push(guess)
				@@letters.delete(guess)
				puts "your guess is good"
				show_gueesed_letters(hiddenword)
				if hiddenword.split(//) == @show
					gameover = true
					puts "Congrats! You've won!!!"
				end	
			else
				@@letters.delete(guess)
			    puts "your guess isn't good"
			    availableguess -= 1
				show_gueesed_letters(hiddenword)
			end

		else 
		    puts "You've already used that letter"
		    availableguess -=1
		    show_gueesed_letters(hiddenword)
		end
	elsif guess == "save"
	      save_game
          puts 'Game has been saved.', "\n"
          game_over = true	
	else 
	    puts "your input is not ok, try again"
	end		

	end
puts "game over"	
	
end

def save_game
  Dir.mkdir('games') unless Dir.exist? 'games'
  filename = 'games/saved.yaml'
  File.open(filename, 'w') do |file|
    file.puts YAML.dump(self)
 end
end

 def load_game
  # assumes file exists
  content = File.open('games/saved.yaml', 'r') { |file| file.read }
  YAML.load(content) # returns a Hangman object
end

def main 
	puts "Welcome to the game Hangman"
	""
	puts "Start new game or load the latest? y/n"
	input = gets.chomp
	if input == 'y'
		start
	elsif input == 'n' 
		load_game
	end
end


end




e = Hangman.new
e.main




	