require_relative "Strategy";

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