require 'open-uri'
require 'typhoeus'
require_relative 'cache'

class Pool
  Typhoeus::Config.cache ||= Cache.new

  POOLS = {
   doge: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   eac: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   rpc: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   lot: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   sbc: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   '42' => "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   dgb: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   ltc: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   kdc: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314"
  }

  REWARD = {
   doge: 500000,
   eac: 11000,
   rpc: 1,
   lot: 32000,
   sbc: 25,
   '42' => 0.000042,
   dgb: 8000,
   ltc: 50,
   kdc: 77
 }

  attr_accessor :coin

  def initialize(coin = :doge)
    @coin = coin

    @@last_doge_block ||= nil
    @@last_eac_block ||= nil
    @@last_rpc_block ||= nil
    @@last_lot_block ||= nil
    @@last_sbc_block ||= nil
    @@last_42_block ||= nil
    @@last_dgb_block ||= nil
    @@last_ltc_block ||= nil
    @@last_kdc_block ||= nil
  end

  def pool_status
    response = grab_and_parse :getpoolstatus

    {
      hash_rate: response['hashrate'] / 1000,
      number_of_workers: response['workers'],
      difficulty: response['networkdiff'],
      average_block_time: seconds_to_minutes_and_hours(response['esttime']),
      time_since_last_block: seconds_to_minutes_and_hours(response['timesincelast'])
    }
  end

  def check_for_new_block
    response = grab_and_parse :getpoolstatus
    current_block_number = response['lastblock']

    last_block = self.class.class_variable_get("@@last_#{coin}_block")
    block_found = last_block && last_block != current_block_number

    self.class.class_variable_set("@@last_#{coin}_block", current_block_number)

    block_info if block_found
  end

  def block_info
    response = grab_and_parse :getblocksfound

    block = response.find { |block| block['height'] == self.class.class_variable_get("@@last_#{coin}_block") }

    {
      reward:    block['amount'].to_i,
      worker:    block['worker_name'],
      found_by:  block['finder'],
      shares:    "#{block['shares']} / #{block['estshares']}"
    }
  end

  private

  def seconds_to_minutes_and_hours(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end

  def grab_and_parse(action)
    url = action(action)

    if action == :getblocksfound
      body = open(url).read
    else
      body = Typhoeus.get(url, nosignal: true).response_body
    end

    JSON.parse(body)[action.to_s]['data']
  end

  def action(action)
    url + "&action=#{action}"
  end

  def url
    "http://pool.chunky.ms/#{coin}/index.php?page=api&api_key=#{POOLS[coin]}"
  end
end
