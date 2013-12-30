require 'open-uri'

class Pool
  POOLS = {
   doge: "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314",
   eac: "b0a9a08cc83c51ec192f7f6f4c801cd932399ff9695aaf79f145637aa4f815c7"
  }

  attr_accessor :coin

  def initialize(coin = :doge)
    @coin = coin
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

    block_found = @last_block_number != current_block_number

    @last_block_number = current_block_number

    block_info if block_found
  end

  def block_info
    response = grab_and_parse :getblocksfound

    block = response.find { |block| block['height'] == @last_block_number }

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
