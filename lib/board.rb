require "./piece.rb"
require "./pawn.rb"
require "./rook.rb"
require "./knight.rb"
require "./bishop.rb"
require "./queen.rb"
require "./king.rb"

class Board
	attr_accessor :hash
	
	def initialize
		@hash = {}
		create_board
	end
	
	def create_board
		1.upto(8) do |i|
			x = 97
			
			1.upto(8) do |j|
				pos = x.chr + "#{i}"
				if (i == 1)
					if (j == 1 || j == 8)
						@hash["#{pos}"] = Rook.new("white", pos)
					elsif (j == 2 || j == 7)
						@hash["#{pos}"] = Knight.new("white", pos)
					elsif (j == 3 || j == 6)
						@hash["#{pos}"] = Bishop.new("white", pos)
					elsif (j == 4)
						@hash["#{pos}"] = Queen.new("white", pos)
					elsif (j == 5)
						@hash["#{pos}"] = King.new("white", pos)
					end
				elsif (i == 2)
					@hash["#{pos}"] = Pawn.new("white", pos)
				elsif (i == 7)
					@hash["#{pos}"] = Pawn.new("black", pos)
				elsif (i == 8)
					if (j == 1 || j == 8)
						@hash["#{pos}"] = Rook.new("black", pos)
					elsif (j == 2 || j == 7)
						@hash["#{pos}"] = Knight.new("black", pos)
					elsif (j == 3 || j == 6)
						@hash["#{pos}"] = Bishop.new("black", pos)
					elsif (j == 4)
						@hash["#{pos}"] = Queen.new("black", pos)
					elsif (j == 5)
						@hash["#{pos}"] = King.new("black", pos)
					end
				else
					@hash["#{pos}"] = nil
				end
				
				x += 1
			end
		end
		draw_board
	end
	
	def draw_board
		system("cls")
		
		puts "    A B C D E F G H"
		puts "   -----------------"
		
		8.downto(1) do |i|
			x = 97
			print "#{i}  "
			
			1.upto(8) do |j|
				pos = x.chr + "#{i}"
				print "|"
				if (@hash["#{pos}"] != nil)
					print "#{@hash["#{pos}"].value}"
				else
					print " "
				end
				x += 1
			end
			
			print "|"
			puts
		end
		
		puts "   -----------------"
		puts "    A B C D E F G H"
	end
end