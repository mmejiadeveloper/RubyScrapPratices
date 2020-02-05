require "HTTParty"
require "Nokogiri"
require 'csv'
require 'digest'
require 'pp'

class LosTiemposScraper
attr_accessor :parse_page

	def initialize()
		doc = HTTParty.get("https://www.lostiempos.com")
		@parse_page ||= Nokogiri::HTML(doc, nil, Encoding::UTF_8.to_s)
	end

	def getPageTitle
		parse_page.css('title').text
	end

	def getMainNewsTitle
		parse_page.css('.views-field .views-field-title a,  .views-row .views-field-title a').map { |link| { "link"=> "https://www.lostiempos.com" + link['href'], "title" => link.text }  }
	end

	def retrieveData
		scrapper =  LosTiemposScraper.new
		pagetTitle = scrapper.getPageTitle
		mainNews = scrapper.getMainNewsTitle
		{"rows" => mainNews, "title" => pagetTitle}
	end

	
end
