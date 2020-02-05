require "HTTParty"
require "Nokogiri"
require 'csv'
require 'digest'
require 'pp'
require_relative 'OpinionScraper'
require_relative 'LosTiemposScraper'

class Scrapper
attr_accessor :parse_page

	def initialize()
		opinionInstance = OpinionScraper.new
		opinionData = opinionInstance.retrieveData
		losTiemposInstance = LosTiemposScraper.new
		losTiemposInstanceData = losTiemposInstance.retrieveData
		writeCSV([opinionData, losTiemposInstanceData])
	end

	def writeCSV (rows)
		CSV.open("../csv/Miguel-Data.csv", "w") do |csv|
			for value in rows do
				csv << [value['title']]
				csv << ["URI", "SCRAPED AT", "ARTICLE DATE", "TITLE", "BODY", "HASH"]
				value["rows"].each_with_index do |item, index|
					if(item["title"].gsub(/\s+/, "").length > 0 && item["title"] != "")
						# puts "\n" + item["link"]
						nokoObject = scrapLink(item["link"])
						body = nokoObject.css(".body").text
						articleDate = nokoObject.css(".content-time, .date-publish").text
						bash = Digest::MD5.hexdigest item["title"] + body
						if(body.strip.length > 0) 
							csv <<  [item["link"], Time.now.strftime("%d/%m/%Y %H:%M"), articleDate.strip, "#{index} - #{item["title"].strip}", body.length > 0 ? body[0,100].strip : "No content", bash]
						end
					end
				end
			end
		end
	end

	def scrapLink (url)
		Nokogiri::HTML(HTTParty.get(url), nil, Encoding::UTF_8.to_s)
	end
	
	scrapper = Scrapper.new
end


