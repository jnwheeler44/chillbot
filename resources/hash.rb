require 'yajl'
require 'open-uri'
require 'openssl'
require 'typhoeus'

class Hash
  Typhoeus::Config.cache ||= Cache.new
  COINWARZ_URL = 'http://www.coinwarz.com/v1/api/coininformation/?apikey=e25ed31c94e1459aa1088195cccbae8f&cointag='

  def self.difficulty_and_reward(coin)
    if Pool::POOLS.keys.include? coin.downcase.to_sym
      coin_param = coin == '42' ? '42' : coin.downcase.to_sym
      { difficulty: Pool.new(coin_param).pool_status[:difficulty], reward: Pool::REWARD[coin_param] }
    else
      body = Typhoeus.get(url(coin)).response_body
      data = JSON.parse(body)['Data']
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
