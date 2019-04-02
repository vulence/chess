require "./piece.rb"
require "colorize"

class Queen < Piece
	def initialize(color, position)
		super
	end
	
	def color?
		if (@color == "white")
			@value = "Q".white
		else
			@value = "Q".red
		end
	end
end