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
    elsif coin.downcase == 'pot' || coin.downcase == 'ruby'
      begin
        body = Typhoeus.get('https://cryptorush.in/index.php?p=trading&m=POT&b=BTC', ssl_verifypeer: false, nosignal: true).response_body
        Nokogiri::HTML.parse(body).css('.leftnav-item-link[href="index.php?p=trading&m=' + coin.upcase + '&b=BTC"] b')[0].text.to_f
      rescue
        puts "error scraping coinmarket"
        0
      end
    else
      begin
        body = Typhoeus.get(URL, nosignal: true).response_body
        JSON.parse(body).find { |item| item['id'] == coin.to_s.downcase }['price_btc']
      rescue
        puts "wtf market is #{coin} on?"
        0
      end
    end
  end

  def self.price_of(coin, number)
    number.to_f * price(coin).to_f
  end
end
