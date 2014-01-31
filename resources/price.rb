require 'yajl'
require 'open-uri'
require 'openssl'
require 'typhoeus'

class Price
  Typhoeus::Config.cache ||= Cache.new
  URL = 'http://www.cryptocoincharts.info/v2/api/listCoins'

  def self.price(coin)
    if coin.downcase == 'dgb' || coin.downcase == 'kdc' || coin.downcase == 'leaf'
      begin
        body = Typhoeus.get('https://www.coinmarket.io', ssl_verifypeer: false, nosignal: true).response_body
        Nokogiri::HTML.parse(body).css(".ticker-#{coin.to_s.upcase}BTC")[0].text
      rescue
        puts "error scraping coinmarket"
        0
      end
    elsif coin.downcase == 'pot'
      0.000025
    else
      body = Typhoeus.get(URL, nosignal: true).response_body
      JSON.parse(body).find { |item| item['id'] == coin.to_s.downcase }['price_btc']
    end
  end

  def self.price_of(coin, number)
    number.to_f * price(coin).to_f
  end
end
