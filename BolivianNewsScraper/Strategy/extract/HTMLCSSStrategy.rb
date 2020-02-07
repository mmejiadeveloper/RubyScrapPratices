require_relative "../transform/Strategy";

class HTMLCSSStrategy < Strategy
	def getPreparedData(rows)
		data = []
		rows.each_with_index do |item, index|
			if(item["title"].gsub(/\s+/, "").length > 0 && item["title"] != "")
				nokoObject = getPageCrawler(item["link"])
				body = nokoObject.css(".body").text
				articleDate = nokoObject.css(".content-time, .date-publish").text
				bash = Digest::MD5.hexdigest item["title"] + body
				if(body.strip.length > 0) 
					data.push([item["link"], Time.now.strftime("%d/%m/%Y %H:%M"), articleDate.strip, "#{index} - #{item["title"].strip}", body.length > 0 ? body[0,100].strip : "No content", bash])
				end
			end
		end
		return data
	end
end