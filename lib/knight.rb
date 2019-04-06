require "./piece.rb"
require "colorize"

class Knight < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "k".white
		else
			@value = "k".red
		end
	end
	
	def valid_move?(hash, next_position)
		next_position_column = next_position[0].ord
		next_position_row = next_position[1].to_i
		current_position_column = @position[0].ord
		current_position_row = @position[1].to_i
		
		if (hash["#{next_position}"] == nil || hash["#{next_position}"].color != self.color)
			if ((next_position_row - current_position_row).abs == 1 && (next_position_column - current_position_column).abs == 2)
				@position = next_position
				return true
			elsif ((next_position_row - current_position_row).abs == 2 && (next_position_column - current_position_column).abs == 1)
				@position = next_position
				return true
			end
			
			return false
		end
		
		return false
	end
end
