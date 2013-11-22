require 'yajl'
require 'open-uri'

module Litecoin
  URL = 'https://btc-e.com/api/2/ltc_usd/ticker'

  class Call
    def initialize
      @stats = call_and_then_parse
    end

    def average
      @stats['ticker']['avg']
    end

    def last
      @stats['ticker']['last']
    end

    def average_price
      average
    end

    def last_price
      last
    end

    def average_display
      average
    end

    def last_display
      last
    end

    def average_worth(usd)
      (usd * average_price).round(2)
    end

    def last_worth(usd)
      (usd * last_price).round(2)
    end

    private

    def call_and_then_parse
      json = open(Litecoin::URL).read
      Yajl::Parser.parse(json)
    end
  end
end
