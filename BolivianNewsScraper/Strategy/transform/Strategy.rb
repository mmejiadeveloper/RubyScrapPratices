class Strategy
	# @abstract
	def getORawObject
		raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
	end

	def parseCrawledData (rawData, url)
		rawData.map { |link| { "link"=> url + link['href'], "title" => link.text }  }
	end

	def getPageCrawler(url)
		puts "loading... " + url 
		doc =HTTParty.get(url)
		Nokogiri::HTML(doc.body.gsub("\0", ""), nil, Encoding::UTF_8.to_s)
	end

	def getPreparedData (data)
		raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
	end
	
end