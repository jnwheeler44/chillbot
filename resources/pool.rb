require 'open-uri'

module Pool
  API_KEY = "6428cc89812e76dc925e4d6f3f27cffe8cdf33e5b4509ab29377fbe2aaff5399"
  URL = "http://pool.chunky.ms/index.php?page=api&api_key=#{API_KEY}"

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

  def self.grab_and_parse(action)
    JSON.parse(open(action(action)).read)[action.to_s]['data']
  end

  def self.action(action)
    URL + "&action=#{action}"
  end
end
