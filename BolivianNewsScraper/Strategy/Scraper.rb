require "HTTParty"
require "Nokogiri"
require 'digest'
require 'pp'
require "awesome_print"
require_relative "LosTiemposStrategy";
require_relative "OpinionStrategy";
require_relative "ETL/LoadMode";

class Scrapper
	attr_writer :strategy, :extractMode

    def initialize(strategy, extractMode)
		@strategy = strategy
		@extractMode = extractMode
	end

	def chageStrategy(strategy)
		@strategy = strategy
	end

	def getScrapedData
		if @extractMode == 'CSS'
			@strategy.getORawObject
		end
	end

	def getPreparedData(rows)
		data = []
		if @extractMode == 'CSS'
			rows.each_with_index do |item, index|
				if(item["title"].gsub(/\s+/, "").length > 0 && item["title"] != "")
					nokoObject = @strategy.getPageCrawler(item["link"])
					body = nokoObject.css(".body").text
					articleDate = nokoObject.css(".content-time, .date-publish").text
					bash = Digest::MD5.hexdigest item["title"] + body
					if(body.strip.length > 0) 
						 x.push([item["link"], Time.now.strftime("%d/%m/%Y %H:%M"), articleDate.strip, "#{index} - #{item["title"].strip}", body.length > 0 ? body[0,100].strip : "No content", bash])
					end
				end
			end
		end
		return data
	end
end

scrapper = Scrapper.new(OpinionStrategy.new, 'CSS') #E

opinionData = scrapper.getScrapedData #T
scrapper.chageStrategy(LostiemposStrategy.new) #E&T
lostiemposData = scrapper.getScrapedData #T

data = scrapper.getPreparedData((lostiemposData + opinionData)) #L
LoadMode.new('CSV', data).save() #L
