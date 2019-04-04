require "./board.rb"
require "yaml"

class Engine
	def initialize
		welcome_screen
		
		@b = Board.new
		@turn = true
		play
	end
	
	def welcome_screen
		system("cls")
		puts "Hello and welcome to Chess!"
		puts "If you wish to save at any moment, input 'save'"
		puts "Do you wish to load a saved game? (y/n)"
		choice = gets.chomp.downcase
		
		choice == "y" ? load_game : return
	end
	
	def play
		while (true)
			@b.draw_board
			
			if (@turn)
				puts "White turn: "
				move = gets.chomp.downcase
			else
				puts "Red turn: "
				move = gets.chomp.downcase
			end
			
			check = input_check(move, @turn)
			
			if (!check || check == 1)
				next
			end
			
			current_pos = move[0..1]
			next_pos = move[3..4]
			
			if (@b.hash["#{current_pos}"].valid_move?(@b.hash, next_pos))
				@b.hash["#{next_pos}"] = @b.hash["#{current_pos}"]
				@b.hash["#{current_pos}"] = nil
				@turn = !@turn
			else
				puts "Invalid move"
				sleep(1)
				next
			end
		end
	end
	
	def input_check(move, b)
		if (move == "save")
			save_game
			return 1
		elsif (move == "load")
			load_game
			return 1
		elsif (move.length != 5 || move =~ /[^1-8a-h\s]/)
			puts "Invalid input"
			sleep(1)
			return false
		elsif (@b.hash["#{move[0..1]}"] == nil)
			puts "You have selected a field with no playable figure"
			sleep(1)
			return false
		elsif (b && @b.hash["#{move[0..1]}"].color != "white")
			puts "It's other player's turn"
			sleep(1)
			return false
		elsif (!b && @b.hash["#{move[0..1]}"].color != "red")
			puts "It's other player's turn"
			sleep(1)
			return false
		end
		
		return true
	end
	
	def save_game
		puts "Enter the name of the save file: "
		name = gets.chomp.downcase
		File.open("../#{name}.yaml", "w").write(YAML.dump(self))
		
		puts "File saved successfully!"
		sleep(1)
	end
	
	def load_game
		puts "Please enter the name of the save file: "
		name = gets.chomp.downcase
		
		game = YAML.load(File.open("../#{name}.yaml"))
		game.play
	end
end

Engine.new