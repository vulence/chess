require "./piece.rb"
require "colorize"

class Pawn < Piece
	attr_accessor :passant
	
	def initialize(color, position)
		super
		@passant = false
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
		en_passant?(next_position_row)
	
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
			@position = next_position
			return true
		elsif (en_passant_taking?(hash, next_position))
			@position = next_position
			return true
		else
			return false
		end
	end
	
	def en_passant?(next_row)
		if ((next_row - @position[1].to_i).abs == 2)
			@passant = true
		end
	end
	
	def en_passant_taking?(hash, next_position)
		next_position_column = next_position[0]
		next_position_row = next_position[1].to_i

		if (self.color == "white")
			if (next_position_row == @position[1].to_i + 1 && next_position_column.ord == @position[0].ord + 1)
				right = hash["#{next_position_column}" + "#{@position[1].to_i}"]
				if (right != nil && right.value == "P".red && right.passant == true)
					hash["#{next_position_column}" + "#{@position[1].to_i}"] = nil
					return true
				end
			elsif (next_position_row == @position[1].to_i + 1 && next_position_column.ord == @position[0].ord - 1)
				left = hash["#{next_position_column}" + "#{@position[1].to_i}"]
				if (left != nil && left.value == "P".red && left.passant == true)
					hash["#{next_position_column}" + "#{@position[1].to_i}"] = nil
					return true
				end
			end
		else
			if (next_position_row == @position[1].to_i - 1 && next_position_column.ord == @position[0].ord + 1)
				right = hash["#{next_position_column}" + "#{position[1].to_i}"]
				if (right != nil && right.value == "P".white && right.passant == true)
					hash["#{next_position_column}" + "#{@position[1].to_i}"] = nil
					return true
				end
			elsif (next_position_row == @position[1].to_i - 1 && next_position_column.ord == @position[0].ord - 1)
				left = hash["#{next_position_column}" + "#{@position[1].to_i}"]
				if (left != nil && left.value == "P".white && left.passant == true)
					hash["#{next_position_column}" + "#{@position[1].to_i}"] = nil
					return true
				end
			end
		end
		
		return false
	end
	
	def taking?(hash, next_position)
		next_position_column = next_position[0].ord
		next_position_row = next_position[1].to_i
		current_position_column = @position[0].ord
		current_position_row = @position[1].to_i
			
		if (hash["#{next_position}"] != nil && @color != hash["#{next_position}"].color)
			if (@color == "white" && (next_position_column - current_position_column).abs == 1 && next_position_row - current_position_row == 1)
				return true
			elsif (@color == "red" && (next_position_column - current_position_column).abs == 1 && current_position_row - next_position_row == 1)
				return true
			else
				return false
			end
		end
		
		return false
	end
	
	def promote(hash)
		if (self.color == "white" && @position[1].to_i == 8)
			pos = "#{@position[0]}" + "#{position[1]}"
			puts "You have reached promotion"
			puts "What do you want to promote your pawn to? (queen/knight/rook/bishop)"
			choice = gets.chomp.downcase
			while (choice != "queen" && choice != "knight" && choice != "rook" && choice != "bishop")
				print "Invalid input (queen/knight/rook/bishop)"
				choice = gets.chomp.downcase
			end
			
			case choice
			when "queen"
				hash[pos] = Queen.new("white", pos)
			when "knight"
				hash[pos] = Knight.new("white", pos)
			when "rook"
				hash[pos] = Rook.new("white", pos)
			when "bishop"
				hash[pos] = Bishop.new("white", pos)
			else
				puts "Error"
			end
		elsif (self.color == "red" && @position[1].to_i == 1)
			pos = "#{@position[0]}" + "#{position[1]}"
			puts "You have reached promotion"
			puts "What do you want to promote your pawn to? (queen/knight/rook/bishop)"
			choice = gets.chomp.downcase
			while (choice != "queen" && choice != "knight" && choice != "rook" && choice != "bishop")
				print "Invalid input (queen/knight/rook/bishop)"
				choice = gets.chomp.downcase
			end 
			
			case choice
			when "queen"
				hash[pos] = Queen.new("red", pos)
			when "knight"
				hash[pos] = Knight.new("red", pos)
			when "rook"
				hash[pos] = Rook.new("red", pos)
			when "bishop"
				hash[pos] = Bishop.new("red", pos)
			else
				puts "Error"
			end
		end
	end
end