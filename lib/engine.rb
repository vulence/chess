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
				#b = !b
			else
				puts "Red turn: "
				move = gets.chomp.downcase
				#b = !b
			end
			current_pos = move[0..1]
			next_pos = move[3..4]
		
			if (@b.hash["#{current_pos}"].valid_move?(next_pos, @b.hash["#{next_pos}"]))
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
end

Engine.new