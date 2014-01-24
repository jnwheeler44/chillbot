require 'yajl'
require 'open-uri'
require 'typhoeus'

module Bitcoin
  URL = 'https://data.mtgox.com/api/2/BTCUSD/money/ticker'

  class Call
    def initialize
      @stats = call_and_then_parse
    end

    def average
      @stats['data']['avg']
    end

    def last
      @stats['data']['last']
    end

    def average_price
      average['value'].to_f
    end

    def last_price
      last['value'].to_f
    end

    def average_display
      average['display']
    end

    def last_display
      last['display']
    end

    def good_time_to_buy?
      (average_price / last_price) > 1.085
    end

    def really_good_time_to_buy?
      (average_price / last_price) > 1.17
    end

    def SELL_QUICK_WTF_COME_ON?
      (average_price / last_price) < 0.9
    end

    def HOLY_FUCKING_SHIT_SELL_NOW?
      (average_price / last_price) < 0.8
    end

    def average_worth(usd)
      (usd * average_price).round(2)
    end

    def last_worth(usd)
      (usd * last_price).round(2)
    end

    private

    def call_and_then_parse
      Typhoeus::Config.cache ||= Cache.new

      json = Typhoeus.get(URL).response_body
      Yajl::Parser.parse(json)
    end
  end
end
