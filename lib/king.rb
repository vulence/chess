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
end
