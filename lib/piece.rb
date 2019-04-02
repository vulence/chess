require "./board.rb"

class Piece
	attr_reader :value, :color
	
	def initialize(color, position)
		@color = color
		@position = position
		@value = nil
		@moved = false
		color?
	end
	
	def color?
		if (@color == "white")
			return true
		else
			return false
		end
	end	
	
	def valid_move
	end
end