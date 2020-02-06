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