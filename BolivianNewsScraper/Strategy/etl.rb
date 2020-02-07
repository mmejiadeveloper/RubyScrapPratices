require "HTTParty"
require "Nokogiri"
require 'digest'
require 'pp'
require "awesome_print"
require_relative "transform/LosTiemposStrategy";
require_relative "transform/OpinionStrategy";
require_relative "load/LoadMode";
require_relative "extract/Scraper"

scrapper  = Scraper.new('CSS', 'CSV')
data = scrapper.getScrapedData
scrapper.saveData(data)

# scrapper = Scrapper.new(OpinionStrategy.new, 'CSS') #E

# opinionData = scrapper.getScrapedData #T
# scrapper.chageStrategy(LostiemposStrategy.new) #E&T
# lostiemposData = scrapper.getScrapedData #T

# data = scrapper.getPreparedData((lostiemposData + opinionData)) #L
# LoadMode.new('TXT', data).save() #L