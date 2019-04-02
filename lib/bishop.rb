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
end