require "./piece.rb"
require "colorize"

class Bishop < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "B".white
		else
			@value = "B".red
		end
	end
	
	def valid_move?(hash, next_position)
		next_position_column = next_position[0]
		next_position_row = next_position[1].to_i
		current_position_column = @position[0]
		current_position_row = @position[1].to_i
		
		if ((next_position_column.ord - current_position_column.ord).abs == (next_position_row - current_position_row).abs && (hash["#{next_position}"] == nil || hash["#{next_position}"].color != self.color))
			x = current_position_column.ord + 1	if current_position_column.ord < next_position_column.ord
			x = current_position_column.ord - 1 if current_position_column.ord > next_position_column.ord
			y = current_position_row + 1 if current_position_row < next_position_row
			y = current_position_row - 1 if current_position_row > next_position_row
			
			while (x != next_position_column.ord && y != next_position_row)
				field = x.chr + "#{y}"
				
				if (hash["#{field}"] != nil)
					return false
				end
				
				x += 1 if current_position_column.ord < next_position_column.ord
				x -= 1 if current_position_column.ord > next_position_column.ord
				y += 1 if current_position_row < next_position_row
				y -= 1 if current_position_row > next_position_row
			end
			
			@position = next_position
			return true
		end
		
		return false
	end
end