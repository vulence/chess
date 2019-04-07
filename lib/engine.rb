require "./board.rb"
require "yaml"
require "colorize"

class Engine
	def initialize
		welcome_screen
		
		@b = Board.new
		@turn = true
		@white_king = @b.hash["e1"]
		@black_king = @b.hash["e8"]
		
		play
	end
	
	def welcome_screen
		system("cls")
		puts "Hello and welcome to Chess!"
		puts "If you wish to save at any moment, input 'save'"
		puts "Do you wish to load a saved game? (y/n)"
		choice = gets.chomp.downcase
		while (choice != "y" && choice != "n")
			print "Invalid input (y/n)"
			choice = gets.chomp.downcase
		end
		
		choice == "y" ? load_game : return
	end
	
	def play
		while (true)
			@b.draw_board
			
			if (@turn)
				clear_passant_white
				puts "White turn: "
				move = gets.chomp.downcase
			else
				clear_passant_black
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
				promote_check(next_pos)
				
				check?("white") if @turn
				check?("black") if !@turn
			else
				puts "Invalid move"
				sleep(1)
				next
			end
		end
	end
	
	def clear_passant_white
		@b.hash.each_value do |val|
			if (val.class.to_s == "Pawn" && val.color == "white")
				val.passant = false
			end
		end
	end
	
	def clear_passant_black
		@b.hash.each_value do |val|
			if (val.class.to_s == "Pawn" && val.color != "white")
					val.passant = false
			end
		end
	end
	
	def promote_check(next_pos)
		if (@b.hash["#{next_pos}"].class.to_s == "Pawn")
			@b.hash["#{next_pos}"].promote(@b.hash)
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
	
	def check_white_king?(white_king_column=@white_king.position[0], white_king_row=@white_king.position[1].to_i)
		# BEGIN WHITE KING CHECK
		current = white_king_row + 1
		x = @b.hash["#{white_king_column}" + "#{current}"]
		# white king upwards check
		if (x == nil || x.color != "white")
			while (current < 9)
				x = @b.hash["#{white_king_column}" + "#{current}"]
				if (x != nil && x.color != "white")
					if (x.value == "R".red || x.value == "Q".red)
						return true
					elsif (x.value == "K".red && current == white_king_row + 1)
						return true
					end
				end
				current += 1
			end
		end
		# white king downwards check
		current = white_king_row - 1
		x = @b.hash["#{white_king_column}" + "#{current}"]
		if (x == nil || x.color != "white")
			while (current > 0)
				x = @b.hash["#{white_king_column}" + "#{current}"]
				if (x != nil && x.color != "white")
					if (x.value == "R".red || x.value == "Q".red)
						return true
					elsif (x.value == "K".red && current == white_king_row - 1)
						return true
					end
				end
				current -= 1
			end
		end
		# white king diagonal check
		# up-left diagonal check
		current_row = white_king_row + 1
		current_column = white_king_column.ord - 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "white")
			while (current_row < 9 && current_column > 96)
				x = @b.hash["#{current_column.chr}" +"#{current_row}"]
				if (x != nil && (x.value == "B".red || x.value == "Q".red))
					return true
				elsif (x != nil && (x.value == "K".red || x.value == "P".red && (current_column == white_king_column.ord - 1 && current_row == white_king_row + 1)))
					return true
				end
				current_row += 1
				current_column -= 1
			end
		end
		# up-right diagonal check
		current_row = white_king_row + 1
		current_column = white_king_column.ord + 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "white")
			while (current_row < 9 && current_column < 105)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".red || x.value == "Q".red))
					return true
				elsif (x != nil && (x.value == "K".red || x.value == "P".red && (current_column == white_king_column.ord + 1 && current_row == white_king_row + 1)))
					return true
				end
				current_row += 1
				current_column += 1
			end
		end
		# bottom-left diagonal check
		current_row = white_king_row - 1
		current_column = white_king_column.ord - 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "white")
			while (current_row > 0 && current_column > 96)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".red || x.value == "Q".red))
					return true
				elsif (x != nil && (x.value == "K".red && current_column == white_king_column.ord - 1 && current_row == white_king_row - 1))
					return true
				end
				current_row -= 1
				current_column -= 1
			end
		end
		# bottom-right diagonal check
		current_row = white_king_row - 1
		current_column = white_king_column.ord + 1
		x = @b.hash["#{current_column.ord}" + "#{current_row}"]
		if (x == nil || x.color != "white")
			while (current_row > 0 && current_column < 105)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".red || x.value == "Q".red))
					return true
				elsif (x != nil && (x.value == "K".red && current_column == white_king_column.ord + 1 && current_row == white_king_row - 1))
					return true
				end
				current_row -= 1
				current_column += 1
			end
		end
		# special KNIGHT check
		return true if (@b.hash["#{(white_king_column.ord + 1).chr}" + "#{white_king_row + 2}"] != nil && @b.hash["#{(white_king_column.ord + 1).chr}" + "#{white_king_row + 2}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord + 2).chr}" + "#{white_king_row + 1}"] != nil && @b.hash["#{(white_king_column.ord + 2).chr}" + "#{white_king_row + 1}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord - 1).chr}" + "#{white_king_row + 2}"] != nil && @b.hash["#{(white_king_column.ord - 1).chr}" + "#{white_king_row + 2}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord - 2).chr}" + "#{white_king_row + 1}"] != nil && @b.hash["#{(white_king_column.ord - 2).chr}" + "#{white_king_row + 1}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord + 2).chr}" + "#{white_king_row - 1}"] != nil && @b.hash["#{(white_king_column.ord + 2).chr}" + "#{white_king_row - 1}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord + 1).chr}" + "#{white_king_row - 2}"] != nil && @b.hash["#{(white_king_column.ord + 1).chr}" + "#{white_king_row - 2}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord - 1).chr}" + "#{white_king_row - 2}"] != nil && @b.hash["#{(white_king_column.ord - 1).chr}" + "#{white_king_row - 2}"].value == "k".red)
		return true if (@b.hash["#{(white_king_column.ord - 2).chr}" + "#{white_king_row - 1}"] != nil && @b.hash["#{(white_king_column.ord - 2).chr}" + "#{white_king_row - 1}"].value == "k".red)
		# END OF WHITE KING CHECK
		
		return false
	end
		
	def check_black_king?(black_king_column=@black_king.position[0], black_king_row=@black_king.position[1].to_i)
		# BEGIN BLACK KING CHECK
		current = black_king_row + 1
		x = @b.hash["#{black_king_column}" + "#{current}"]
		# black king upwards check
		if (x == nil || x.color != "red")
			while (current < 9)
				x = @b.hash["#{black_king_column}" + "#{current}"]
				if (x != nil && (x.value == "R".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white && current == black_king_row + 1))
					return true
				end
				current += 1
			end
		end
		# black king downwards check
		current = black_king_row - 1
		x = @b.hash["#{black_king_column}" + "#{current}"]
		if (x == nil || x.color != "red")
			while (current > 0)
				x = @b.hash["#{black_king_column}" + "#{current}"]
				if (x != nil && (x.value == "R".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white && current == black_king_row - 1))
					return true
				end
				current -= 1
			end
		end
		# black king diagonal check
		# up-left diagonal check
		current_column = black_king_column.ord - 1
		current_row = black_king_row + 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "red")
			while (current_column > 96 && current_row < 9)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white && current_row == black_king_row + 1 && current_column == black_king_column.ord - 1))
					return true
				end
				current_column -= 1
				current_row += 1
			end
		end
		# up-right diagonal check
		current_column = black_king_column.ord + 1
		current_row = black_king_row + 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "red")
			while (current_column < 105 && current_row < 9)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white && current_column == black_king_column.ord + 1 && current_row == black_king_row + 1))
					return true
				end
				current_column += 1
				current_row += 1
			end
		end
		# bottom-left diagonal check
		current_column = black_king_column.ord - 1
		current_row = black_king_row - 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "red")
			while (current_column > 96 && current_row > 0)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white || x.value == "P".white && (current_column == black_king_column.ord - 1 && current_row == black_king_row - 1)))
					return true
				end
				current_column -= 1
				current_row -= 1
			end
		end
		# bottom-right diagonal check
		current_column = black_king_column.ord + 1
		current_row = black_king_row - 1
		x = @b.hash["#{current_column.chr}" + "#{current_row}"]
		if (x == nil || x.color != "red")
			while (current_column < 105 && current_row > 0)
				x = @b.hash["#{current_column.chr}" + "#{current_row}"]
				if (x != nil && (x.value == "B".white || x.value == "Q".white))
					return true
				elsif (x != nil && (x.value == "K".white || x.value == "P".white && (current_column == black_king_column.ord + 1 && current_row == black_king_row - 1)))
					return true
				end
				current_column += 1
				current_row -= 1
			end
		end
		# special knight check
		return true if (@b.hash["#{(black_king_column.ord + 1).chr}" + "#{black_king_row + 2}"] != nil && @b.hash["#{(black_king_column.ord + 1).chr}" + "#{black_king_row + 2}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord + 2).chr}" + "#{black_king_row + 1}"] != nil && @b.hash["#{(black_king_column.ord + 2).chr}" + "#{black_king_row + 1}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord - 1).chr}" + "#{black_king_row + 2}"] != nil && @b.hash["#{(black_king_column.ord - 1).chr}" + "#{black_king_row + 2}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord - 2).chr}" + "#{black_king_row + 1}"] != nil && @b.hash["#{(black_king_column.ord - 2).chr}" + "#{black_king_row + 1}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord + 2).chr}" + "#{black_king_row - 1}"] != nil && @b.hash["#{(black_king_column.ord + 2).chr}" + "#{black_king_row - 1}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord + 1).chr}" + "#{black_king_row - 2}"] != nil && @b.hash["#{(black_king_column.ord + 1).chr}" + "#{black_king_row - 2}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord - 1).chr}" + "#{black_king_row - 2}"] != nil && @b.hash["#{(black_king_column.ord - 1).chr}" + "#{black_king_row - 2}"].value == "k".white)
		return true if (@b.hash["#{(black_king_column.ord - 2).chr}" + "#{black_king_row - 1}"] != nil && @b.hash["#{(black_king_column.ord - 2).chr}" + "#{black_king_row - 1}"].value == "k".white)
		# END OF BLACK KING CHECK
		
		return false
	end
	
	def check?(color)
		mate = true
		if (color == "white")
			if (check_white_king?)
				puts "White in check"
				sleep(2)
				white_king_column = @white_king.position[0].ord
				white_king_row = @white_king.position[1].to_i
				if (white_king_column - 1 > 96 && white_king_row + 1 < 9)
					mate = false if (!check_white_king((white_king_column - 1).chr, white_king_row + 1))
				end
				if (white_king_row + 1 < 9)
					mate = false if (!check_white_king(white_king_column.chr, white_king_row + 1))
				end
				if (white_king_column + 1 < 105 && white_king_row + 1 < 9)
					mate = false if (!check_white_king((white_king_column + 1).chr, white_king_row + 1))
				end
				if (white_king_column - 1 > 96)
					mate = false if (!check_white_king((white_king_column - 1).chr, white_king_row))
				end
				if (white_king_column + 1 < 105)
					mate = false if (!check_white_king((white_king_column + 1).chr, white_king_row))
				end
				if (white_king_column - 1 > 96 && white_king_row - 1 > 0)
					mate = false if (!check_white_king((white_king_column - 1).chr, white_king_row - 1))
				end
				if (white_king_row - 1 > 0)
					mate = false if (!check_white_king(white_king_column.chr, white_king_row - 1))
				end
				if (white_king_column + 1 < 105 && white_king_row - 1 > 0)
					mate = false if (!check_white_king((white_king_column + 1).chr, white_king_row - 1))
				end
			else
				mate = false
			end
			
			if (mate)
				puts "Check-mate"
				sleep(10)
			end
		else
			if (check_black_king?)
				puts "Black in check"
				sleep(2)
				black_king_column = @black_king.position[0].ord
				black_king_row = @black_king.position[1].to_i
				if (black_king_column - 1 > 96 && black_king_row + 1 < 9)
					mate = false if (!check_black_king_king((black_king_column - 1).chr, black_king_row + 1))
				end
				if (black_king_row + 1 < 9)
					mate = false if (!check_black_king(black_king_column.chr, black_king_row + 1))
				end
				if (black_king_column + 1 < 105 && black_king_row + 1 < 9)
					mate = false if (!check_black_king((black_king_column + 1).chr, black_king_row + 1))
				end
				if (black_king_column - 1 > 96)
					mate = false if (!check_black_king((black_king_column - 1).chr, black_king_row))
				end
				if (black_king_column + 1 < 105)
					mate = false if (!check_black_king((black_king_column + 1).chr, black_king_row))
				end
				if (black_king_column - 1 > 96 && black_king_row - 1 > 0)
					mate = false if (!check_black_king((black_king_column - 1).chr, black_king_row - 1))
				end
				if (black_king_row - 1 > 0)
					mate = false if (!check_black_king(black_king_column.chr, black_king_row - 1))
				end
				if (black_king_column + 1 < 105 && black_king_row - 1 > 0)
					mate = false if (!check_black_king((black_king_column + 1).chr, wblack_king_row - 1))
				end
			else
				mate = false
			end
			
			if (mate)
				puts "Check-mate"
				sleep(10)
			end
		end
	end
end

Engine.new