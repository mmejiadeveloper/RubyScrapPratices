require 'csv'

class LoadMode
	attr_accessor :mode, :header, :data
	def initialize(mode, data)
		@mode = mode
		@header = ["URI", "SCRAPED AT", "ARTICLE DATE", "TITLE", "BODY", "HASH"]
		@data = data
	end

	def save
		if (@mode == 'CSV')
			writeCSV()
			ap "Data saved in #{@Mode} file"
		end
	end

	def writeCSV
		CSV.open("../csv/ScrapedData.csv", "w") do |csv|
			csv << @header
			for value in @data do
				csv << value
			end
		end
	end

	def dbSave
		# DB
	end
end