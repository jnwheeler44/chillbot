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
      begin
        body = Typhoeus.get('https://freshmarket.co.in/index.php?page=trade&market=124', ssl_verifypeer: false, nosignal: true).response_body
        ltc_price = Nokogiri::HTML.parse(body).css("#user-orders tr:nth-child(2) > td:nth-child(1)")[0].text

        ltc_price.to_f * price('ltc').to_f
      rescue
        puts "error scraping coinmarket"
        0
      end
    else
      body = Typhoeus.get(URL, nosignal: true).response_body
      JSON.parse(body).find { |item| item['id'] == coin.to_s.downcase }['price_btc']
    end
  end

  def self.price_of(coin, number)
    number.to_f * price(coin).to_f
  end
end
