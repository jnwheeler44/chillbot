require 'yajl'
require 'open-uri'

class Dogecoin < Rubot::WebResource
  get :price, "https://coinedup.com/OrderBook?market=DOGE&base=BTC" do |doc|
    doc.css('#elementDisplayLastPrice div')
  end

  def self.price_of(number)
    number.to_f * price.to_f
  end
end
