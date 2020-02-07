require 'csv'
require_relative "LoadStrategy";

class CSVLoadStrategy < LoadStrategy
attr_accessor :fileName, :header
	def initialize()
		@header = ["URI", "SCRAPED AT", "ARTICLE DATE", "TITLE", "BODY", "HASH"]
		@fileName = '../files/csv/ScrapedData.csv'
	end
	
	def createFile(data)
		CSV.open(@fileName, "w") do |csv|
			csv << @header
			for value in data do
				csv << value
			end
		end
		ap "File generated as csv!"
	end
end
