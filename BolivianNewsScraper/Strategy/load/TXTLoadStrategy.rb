require_relative "LoadStrategy";

class TXTLoadStrategy < Strategy
attr_accessor :fileName
	def initialize()
		@fileName = '../files/txt/ScrapedData.txt'
	end

	def createFile(data)
		File.open(@fileName, "w") do |file|
			for value in data do
				file.write(data)
			end
		end
		ap "File generated as txt!"
	end
		
end
