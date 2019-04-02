require "./piece.rb"
require "colorize"

class Pawn < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "P".white
		else
			@value = "P".red
		end
	end
	
	def valid_move?(hash, next_position)
		next_position_column = next_position[0]
		next_position_row = next_position[1].to_i
		current_position_column = @position[0]
		current_position_row = @position[1].to_i
	
		if (current_position_column == next_position_column && hash["#{next_position}"] == nil)
			if (@color == "white")
				if (next_position_row - current_position_row == 2 && @moved == false)
					@position = next_position
					@moved = true
					return true
				elsif (next_position_row - current_position_row == 1)
					@position = next_position
					@moved = true
					return true
				end
			else
				if (next_position_row - current_position_row == -2 && @moved == false)
					@position = next_position
					@moved = true
					return true
				elsif (next_position_row - current_position_row == -1)
					@position = next_position
					@moved = true
					return true
				end
			end
		elsif (taking?(hash, next_position))
			return true
		elsif (en_passant?)
			return true
		else
			return false
		end
	end
	
	def en_passant?
		
	end
	
	def taking?(hash, next_position)
		next_position_column = next_position[0].ord
		next_position_row = next_position[1].to_i
		current_position_column = @position[0].ord
		current_position_row = @position[1].to_i
			
		if (hash["#{next_position}"] != nil && @color != hash["#{next_position}"].color)
			if (@color == "white" && (next_position_column - current_position_column).abs == 1 && next_position_row - current_position_row == 1)
				return true
			elsif (@color == "black" && (next_position_column - current_position_column).abs == 1 && current_position_row - next_position_row == 1)
				return true
			else
				return false
			end
		end
		
		return false
	end
end