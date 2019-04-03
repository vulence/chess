require "./piece.rb"
require "colorize"

class King < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "K".white
		else
			@value = "K".red
		end
	end
	
	def valid_move?(hash, next_position)
		next_position_column = next_position[0]
		next_position_row = next_position[1].to_i
		current_position_column = @position[0]
		current_position_row = @position[1].to_i
		
		if ((current_position_column.ord - next_position_column.ord).abs <= 1 && (current_position_row - next_position_row).abs <= 1 && (hash["#{next_position}"] == nil || hash["#{next_position}"].color != self.color))
			@position = next_position
			return true
		end
		
		return false
	end
end
