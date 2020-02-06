require_relative "Strategy";

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
