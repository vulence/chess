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
end
