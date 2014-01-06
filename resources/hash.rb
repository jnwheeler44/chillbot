require 'yajl'
require 'open-uri'
require 'openssl'

class Hash
  COINWARZ_URL = 'http://www.coinwarz.com/v1/api/coininformation/?apikey=e25ed31c94e1459aa1088195cccbae8f&cointag='

  def self.difficulty_and_reward(coin)
    case coin.upcase
    when 'DOGE'
      { difficulty: Pool.new(:doge).pool_status[:difficulty], reward: 500000 }
    when 'EAC'
      { difficulty: Pool.new(:eac).pool_status[:difficulty], reward: 10500 }
    else
      data = JSON.parse(open(url(coin).read))['Data']
      { difficulty: data['Difficulty'], reward: data['BlockReward'] }
    end
  end

  def self.url(coin)
    COINWARZ_URL + coin.upcase
  end

  def self.coins_per_day(difficulty_and_reward, khash)
    numerator = difficulty_and_reward[:difficulty] * 2**32
    denominator = khash * 1000

    average_block_seconds = numerator / denominator

    seconds_per_day = 60 * 60 * 24
    blocks_per_day = seconds_per_day / average_block_seconds

    blocks_per_day * reward
  end
end
