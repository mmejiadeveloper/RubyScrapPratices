require_relative "HTMLCSSStrategy";
require_relative "PDFStrategy";
require_relative "../transform/LostiemposStrategy";
require_relative "../transform/OpinionStrategy";

class Scraper
	attr_accessor :extractMode, :data, :extractStrategy, :loadStrategy, :filetype

	def initialize(mode, filetype)
		@filetype = filetype
		if mode == 'CSS'
			@extractStrategy = HTMLCSSStrategy.new
		elsif mode == 'PDF'
			@extractStrategy = PDFStrategy.new
		end
	end
	
	def getScrapedData
		lostiemposData = LostiemposStrategy.new.getORawObject
		opinionData = OpinionStrategy.new.getORawObject
		result = (lostiemposData + opinionData)
		return @extractStrategy.getPreparedData(result)
	end

	def saveData(data)
		LoadMode.new(@filetype, data).save()
	end
end