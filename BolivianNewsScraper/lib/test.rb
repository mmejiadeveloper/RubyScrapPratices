require "HTTParty"
require "Nokogiri"
require 'csv'
require 'digest'
require 'pp'
require "awesome_print"

class Scrapper
	attr_writer :strategy

	def initialize(strategy)
		@strategy = strategy
	end

	def chageStrategy(strategy)
		@strategy = strategy
	end

	def getScrapedData
		@strategy.getORawObject
	end

	def writeCSV (rows)
		CSV.open("../csv/Miguel-Data.csv", "w") do |csv|
			csv << ["URI", "SCRAPED AT", "ARTICLE DATE", "TITLE", "BODY", "HASH"]
			rows.each_with_index do |item, index|
				if(item["title"].gsub(/\s+/, "").length > 0 && item["title"] != "")
					nokoObject = @strategy.getPageCrawler(item["link"])
					body = nokoObject.css(".body").text
					articleDate = nokoObject.css(".content-time, .date-publish").text
					bash = Digest::MD5.hexdigest item["title"] + body
					if(body.strip.length > 0) 
						csv <<  [item["link"], Time.now.strftime("%d/%m/%Y %H:%M"), articleDate.strip, "#{index} - #{item["title"].strip}", body.length > 0 ? body[0,100].strip : "No content", bash]
					end
				end
			end
		end
		ap "Done"
	end
end

class Strategy
	# @abstract
	def getORawObject
		raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
	end

	def parseCrawledData (rawData, url)
		rawData.map { |link| { "link"=> url + link['href'], "title" => link.text }  }
	end

	def getPageCrawler(url)
		ap "loading... " + url 
		Nokogiri::HTML(HTTParty.get(url).body, nil, Encoding::UTF_8.to_s)
	end
	
end

class OpinionStrategy < Strategy
attr_accessor :webSiteData, :url, :crawler
	def initialize()
		@webSiteData = {
			"cssSelectors" => {
				"articlesSection" => '.article-data h2 a',
				"albumSection" => '.album-data a',
				"moreNewsSection" => '.more-news-section .data-title a'
			},
		}
		@url = "https://www.opinion.com.bo"
		@cralwer = getPageCrawler(@url)
	end

	def getORawObject 
		[
			parseCrawledData(@cralwer.css(@webSiteData['cssSelectors']["articlesSection"]),@url),
			parseCrawledData(@cralwer.css(@webSiteData['cssSelectors']["albumSection"]),@url),
			parseCrawledData(@cralwer.css(@webSiteData['cssSelectors']["moreNewsSection"]),@url),
		].flatten
	end

end

class LostiemposStrategy < Strategy
	attr_accessor :webSiteData, :url, :crawler
		def initialize()
			@webSiteData = {
				"cssSelectors" => {
					"all" => ".views-field .views-field-title a,  .views-row .views-field-title a"
				}
			}
			@url = "https://www.lostiempos.com"
			@cralwer = getPageCrawler(@url)
		end
	
		def getORawObject 
			parseCrawledData(@cralwer.css(@webSiteData['cssSelectors']["all"]), @url)
		end
	
	end

scrapper = Scrapper.new(OpinionStrategy.new)
opinionData = scrapper.getScrapedData
scrapper.chageStrategy(LostiemposStrategy.new)
lostiemposData = scrapper.getScrapedData
scrapper.writeCSV((lostiemposData + opinionData))






























































# class Scrapper
# attr_accessor :parse_page, :sitesInformation, :mergeData

# 	def initialize
# 		ap "Starting ... "
# 		@sitesInformation = {
# 			"opinion" => {
# 				"cssSelectors" => {
# 					"articlesSection" => '.article-data h2 a',
# 					"albumSection" => '.album-data a',
# 					"moreNewsSection" => '.more-news-section .data-title a'
# 				},
# 				"url" => "https://www.opinion.com.bo"
# 			},
# 			"lostiempos" => {
# 				"cssSelectors" => {
# 					"all" => ".views-field .views-field-title a,  .views-row .views-field-title a"
# 				},
# 				"url" => "https://www.lostiempos.com"
# 			}
# 		}
# 	end

# 	def getPageTitle
# 		parse_page.css('title').text
# 	end

# 	def getPageCrawler(url)
# 		ap "loading... " + url 
# 		doc = HTTParty.get(url)
# 		Nokogiri::HTML(doc.body, nil, Encoding::UTF_8.to_s)
# 	end

# 	def getLosTiemposRawObject
# 		cralwer = getPageCrawler(@sitesInformation['lostiempos']['url'])
# 		url = @sitesInformation['lostiempos']['url']
# 		parseCrawledData(cralwer.css(@sitesInformation['lostiempos']['cssSelectors']["all"]), url)
# 	end

# 	def getOpinionesRawObject 
# 		cralwer = getPageCrawler(@sitesInformation['opinion']['url'])
# 		url = @sitesInformation['opinion']['url']
# 		[
# 			parseCrawledData(cralwer.css(@sitesInformation['opinion']['cssSelectors']["articlesSection"]), url),
# 			parseCrawledData(cralwer.css(@sitesInformation['opinion']['cssSelectors']["albumSection"]), url),
# 			parseCrawledData(cralwer.css(@sitesInformation['opinion']['cssSelectors']["moreNewsSection"]), url)
# 		].flatten
# 	end

# 	def parseCrawledData (rawData, url)
# 		rawData.map { |link| { "link"=> url + link['href'], "title" => link.text }  }
# 	end

# 	def writeCSV (rows)
# 		CSV.open("../csv/Miguel-Data.csv", "w") do |csv|
# 			csv << ["URI", "SCRAPED AT", "ARTICLE DATE", "TITLE", "BODY", "HASH"]
# 			rows.each_with_index do |item, index|
# 				if(item["title"].gsub(/\s+/, "").length > 0 && item["title"] != "")
# 					nokoObject = getPageCrawler(item["link"])
# 					body = nokoObject.css(".body").text
# 					articleDate = nokoObject.css(".content-time, .date-publish").text
# 					bash = Digest::MD5.hexdigest item["title"] + body
# 					if(body.strip.length > 0) 
# 						csv <<  [item["link"], Time.now.strftime("%d/%m/%Y %H:%M"), articleDate.strip, "#{index} - #{item["title"].strip}", body.length > 0 ? body[0,100].strip : "No content", bash]
# 					end
# 				end
# 			end
# 		end
# 		ap "Done"
# 	end
	
# 	scrapper = Scrapper.new
# 	losTiemposData = scrapper.getLosTiemposRawObject
# 	opinionesData = scrapper.getOpinionesRawObject
# 	scrapper.writeCSV(opinionesData + losTiemposData)
# end


