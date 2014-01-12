require 'yajl'
require 'open-uri'
require 'openssl'

class Hash
  COINWARZ_URL = 'http://www.coinwarz.com/v1/api/coininformation/?apikey=e25ed31c94e1459aa1088195cccbae8f&cointag='

  def self.difficulty_and_reward(coin)
    case coin.to_s.upcase
    when 'DOGE'
      { difficulty: Pool.new(:doge).pool_status[:difficulty], reward: 500000 }
    when 'EAC'
      { difficulty: Pool.new(:eac).pool_status[:difficulty], reward: 10500 }
    when 'RPC'
      { difficulty: Pool.new(:rpc).pool_status[:difficulty], reward: 1 }
    when 'LOT'
      { difficulty: Pool.new(:lot).pool_status[:difficulty], reward: 32000 }
    when 'SBC'
      { difficulty: Pool.new(:sbc).pool_status[:difficulty], reward: 25 }
    else
      data = JSON.parse(open(url(coin)).read)['Data']
      { difficulty: data['Difficulty'], reward: data['BlockReward'] }
    end
  end

  def self.url(coin)
    COINWARZ_URL + coin.upcase
  end

  def self.coins_for(coin, khash)
    difficulty_and_reward = Hash.difficulty_and_reward(coin)
    Hash.coins_per_day(difficulty_and_reward, khash)
  end

  def self.coins_per_day(difficulty_and_reward, khash)
    numerator = difficulty_and_reward[:difficulty] * 2**32
    denominator = khash.to_f * 1000

    average_block_seconds = numerator / denominator

    seconds_per_day = 60 * 60 * 24
    blocks_per_day = seconds_per_day / average_block_seconds

    blocks_per_day * difficulty_and_reward[:reward]
  end

  def self.btc_per_day(coin, number)
    Price.price_of(coin, number)
  end

  def self.usd_per_day(btc)
    btc_response = Bitcoin::Call.new
    btc_response.last_worth(btc)
  end

  def self.chunky_profits(khash = 1000)
    Pool::POOLS.keys.map do |coin|
      coins = coins_for(coin, khash)
      btc = btc_per_day(coin, coins)
      usd = usd_per_day(btc)

      [coin, btc, usd]
    end.sort_by(&:last).reverse
  end

  def self.chunky_top_profit
    chunky_profits.max_by(&:last)
  end
end
