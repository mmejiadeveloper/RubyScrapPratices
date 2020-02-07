require 'csv'
require_relative "CSVLoadStrategy";
require_relative "TXTLoadStrategy";

#context
class LoadMode
	attr_accessor :mode, :data, :loadStrategy
	def initialize(mode, data)
		@mode = mode
		@data = data
	end

	def save
		if (@mode == 'CSV')
			@loadStrategy = CSVLoadStrategy.new
		elsif (@mode == 'TXT')
			@loadStrategy = TXTLoadStrategy.new
		end
		@loadStrategy.createFile(@data)
	end
end