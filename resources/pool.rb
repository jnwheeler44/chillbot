require 'open-uri'

class Pool
  POOLS = {
   doge: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   eac: "b0a9a08cc83c51ec192f7f6f4c801cd932399ff9695aaf79f145637aa4f815c7",
   rpc: "9a3505cce3348c3e47a247c2d4b7991b5ae74fc7ebf71a27a950699f2b647840",
   lot: "5db84a8df70b9d8d5a763937ae155e184ba71014ef6868c9673ac4da242ad711"
  }

  attr_accessor :coin

  def initialize(coin = :doge)
    @coin = coin

    @@last_doge_block ||= nil
    @@last_eac_block ||= nil
    @@last_rpc_block ||= nil
    @@last_lot_block ||= nil
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
    JSON.parse(open(action(action)).read)[action.to_s]['data']
  end

  def action(action)
    url + "&action=#{action}"
  end

  def url
    "http://pool.chunky.ms/#{coin}/index.php?page=api&api_key=#{POOLS[coin]}"
  end
end
