require "HTTParty"
require "Nokogiri"
require 'csv'
require 'digest'
require 'pp'

class OpinionScraper
attr_accessor :parse_page

	def initialize()
		doc = HTTParty.get("https://www.opinion.com.bo")
		@parse_page ||= Nokogiri::HTML(doc, nil, Encoding::UTF_8.to_s)
	end

	def getPageTitle
		parse_page.css('title').text
	end

	def getAllArticles
		articles = parse_page.css('.article-data h2 a').map { |link| { "link"=> "https://www.opinion.com.bo" + link['href'], "title" => link.text }  }
	end

	def getAllAlbums
		parse_page.css('.album-data a').map { |link| { "link"=> "https://www.opinion.com.bo" + link['href'], "title" => link.text }  }
	end

	def getMoreNews
		parse_page.css('.more-news-section .data-title a').map { |link| { "link"=> "https://www.opinion.com.bo" +link['href'], "title" => link.text }  }
	end

	def retrieveData
		scrapper =  OpinionScraper.new
		pagetTitle = scrapper.getPageTitle
		articles = scrapper.getAllArticles
		albums = scrapper.getAllAlbums
		moreNews = scrapper.getMoreNews
		all = articles + albums + moreNews
		{"rows" => all, "title" => pagetTitle}
	end

	
end
