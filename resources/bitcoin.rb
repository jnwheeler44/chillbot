require 'yajl'
require 'open-uri'
require 'typhoeus'

module Bitcoin
  URL = 'https://api.bitcoinaverage.com/no-mtgox/ticker/USD/'

  class Call
    def initialize
      @stats = call_and_then_parse
    end

    def last
      @stats['last']
    end

    def last_price
      last.to_f
    end

    def last_display
      last
    end

    def last_worth(usd)
      (usd * last_price).round(2)
    end

    private

    def call_and_then_parse
      Typhoeus::Config.cache ||= Cache.new

      json = Typhoeus.get(URL, nosignal: true).response_body
      Yajl::Parser.parse(json)
    end
  end
end
