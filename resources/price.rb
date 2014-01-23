require 'yajl'
require 'open-uri'
require 'openssl'

class Price
  URL = 'http://www.cryptocoincharts.info/v2/api/listCoins'

  def self.price(coin)
    if coin.to_s.downcase == 'dgb'
      0.00000114
    else
      JSON.parse(open(URL).read).find { |item| item['id'] == coin.to_s.downcase }['price_btc']
    end
  end

  def self.price_of(coin, number)
    number.to_f * price(coin).to_f
  end
end
