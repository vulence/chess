require "./piece.rb"
require "colorize"

class Rook < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "R".white
		else
			@value = "R".red
		end
	end
	
	def valid_move?(hash, next_position)
		next_position_column = next_position[0]
		next_position_row = next_position[1].to_i
		current_position_column = @position[0]
		current_position_row = @position[1].to_i
		
		if (hash["#{next_position}"] == nil || hash["#{next_position}"].color != self.color)
			if (current_position_column == next_position_column)
				x = current_position_row + 1 if current_position_row < next_position_row
				x = current_position_row - 1 if current_position_row > next_position_row
			
				while (x != next_position_row)
					field = current_position_column + "#{x}"
				
					if (hash["#{field}"] != nil)
						return false
					end
				
					x += 1 if current_position_row < next_position_row
					x -= 1 if current_position_row > next_position_row
				end
		
				@position = next_position
				return true
			
			elsif (current_position_row == next_position_row)		
				x = current_position_column.ord + 1 if current_position_column.ord < next_position_column.ord
				x = current_position_column.ord - 1 if current_position_column.ord > next_position_column.ord
			
				while (x != next_position_column.ord)
					field = x.chr + "#{current_position_row}"
				
					if (hash["#{field}"] != nil)
						return false
					end
				
					x += 1 if current_position_column.ord < next_position_column.ord
					x -= 1 if current_position_column.ord > next_position_column.ord
				end
			
				@position = next_position
				return true
			end
		end
		
		return false
	end
end
