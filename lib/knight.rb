require "./piece.rb"
require "colorize"

class Knight < Piece
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