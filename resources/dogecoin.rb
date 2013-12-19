require 'yajl'
require 'open-uri'
require 'openssl'

class Dogecoin
  URL = 'http://pubapi.cryptsy.com/api.php?method=marketdatav2'

  def self.price
    JSON.parse(open(URL).read)['return']['markets']['DOGE/BTC']['lasttradeprice']
  end

  def self.price_of(number)
    number.to_f * price.to_f
  end
end
