require 'open-uri'

module Pool
  API_KEY = "6428cc89812e76dc925e4d6f3f27cffe8cdf33e5b4509ab29377fbe2aaff5399"
  URL = "http://pool.chunky.ms/index.php?page=api&api_key=#{API_KEY}"

  def self.pool_status
    response = grab_and_parse :getpoolstatus

    {
      hash_rate: response['hashrate'] / 1000,
      number_of_workers: response['workers'],
      difficulty: response['networkdiff'],
      average_block_time: seconds_to_minutes_and_hours(response['esttime']),
      time_since_last_block: seconds_to_minutes_and_hours(response['timesincelast'])
    }
  end

  def self.check_for_new_block
    response = grab_and_parse :getpoolstatus
    current_block_number = response['lastblock']

    block_found = @last_block_number != current_block_number

    @last_block_number = current_block_number

    block_info if block_found
  end

  def self.block_info
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

  def self.seconds_to_minutes_and_hours(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end

  def self.grab_and_parse(action)
    JSON.parse(open(action(action)).read)[action.to_s]['data']
  end

  def self.action(action)
    URL + "&action=#{action}"
  end
end
