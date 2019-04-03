require "./board.rb"

class Engine
	def initialize
		@b = Board.new
		play
	end
	
	def play
		b = true
		while (true)
			if (b)
				puts "White turn: "
				move = gets.chomp.downcase
			else
				puts "Red turn: "
				move = gets.chomp.downcase
			end
			
			if (!input_check(move, b))
				next
			end
			
			current_pos = move[0..1]
			next_pos = move[3..4]
		
			if (@b.hash["#{current_pos}"].valid_move?(@b.hash, next_pos))
				@b.hash["#{next_pos}"] = @b.hash["#{current_pos}"]
				@b.hash["#{current_pos}"] = nil
				b = !b
			else
				puts "Invalid move"
				next
			end

			@b.draw_board
		end
	end
	
	def input_check(move, b)
		if (move.length != 5 || move =~ /[^1-8a-h\s]/)
			puts "Invalid input"
			return false
		elsif (@b.hash["#{move[0..1]}"] == nil)
			puts "You have selected a field with no playable figure"
			return false
		elsif (b && @b.hash["#{move[0..1]}"].color != "white")
			puts "It's other player's turn"
			return false
		elsif (!b && @b.hash["#{move[0..1]}"].color != "red")
			puts "It's other player's turn"
			return false
		end
		
		return true
	end
end

Engine.new