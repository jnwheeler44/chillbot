require 'open-uri'
require 'typhoeus'
require_relative 'cache'

class Pool
  Typhoeus::Config.cache ||= Cache.new
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  API_KEY = "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314"

  COIN_REWARD = {
   'rpc' => 1,
   'dgb' => 8000,
   'kdc' => 16,
   'ruby' => 500,
   'pot' => 420,
   'sun' => 10,
   'ron' => 0.125,
   'flap' => 500000,
   'aur' => 25
 }

  attr_accessor :coin

  def initialize(coin = 'doge')
    @coin = coin
  end

  def pool_status(options = {})
    if options[:uncached]
      response = grab_uncached_and_parse :getpoolstatus
    else
      response = grab_and_parse :getpoolstatus
    end

    {
      hash_rate: response['hashrate'] / 1000,
      number_of_workers: response['workers'],
      difficulty: response['networkdiff'],
      average_block_time: seconds_to_minutes_and_hours(response['esttime']),
      time_since_last_block: seconds_to_minutes_and_hours(response['timesincelast'])
    }
  end

  def block_info
    response = grab_uncached_and_parse :getblocksfound

    block = response.first

    {
      reward:    block['amount'].to_i,
      worker:    block['worker_name'],
      found_by:  block['finder'],
      shares:    "#{block['shares']} / #{block['estshares']}"
    }
  end

  def self.multiport_status
    body = open('https://chunkypools.com/api/pool/status').read
    status = JSON.parse(body)

    {
      workers: status['multiport_workers'],
      coin: status['multiport_coin'],
      rate: status['pools'].find { |pool| pool['coin'] == status['multiport_coin'] }['hash_rate']
    }
  end

  private

  def seconds_to_minutes_and_hours(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end

  def grab_and_parse(action)
    url = action(action)
    body = Typhoeus.get(url, nosignal: true).response_body
    JSON.parse(body)[action.to_s]['data']
  end

  def grab_uncached_and_parse(action)
    url = action(action)
    body = open(url).read
    JSON.parse(body)[action.to_s]['data']
  end

  def url
    "https://chunkypools.com/#{coin}/index.php?page=api&api_key=#{API_KEY}"
  end

  def action(action)
    url + "&action=#{action}"
  end
end
