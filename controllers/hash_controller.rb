class HashController < Rubot::Controller
  command :khash, :perday do
    args = message.text.split

    if args.size == 2
      do_shit_with_numbers(args[0], args[1])
    else
      reply "usage: !khash [coin] [khash]"
    end
  end

  command :khashdiff do
    args = message.text.split

    if args.size == 3
      do_shit_aight(args[0], args[1], args[2])
    else
      reply "usage: !khashdiff [diff] [reward] [khash]"
    end
  end

  def do_shit_aight(diff, reward, khash)
    difficulty_and_reward = { difficulty: diff.to_f, reward: reward.to_f }
    coins = Hash.coins_per_day(difficulty_and_reward, khash)

    args = [khash, diff.to_f, reward.to_f, coins]
    reply "[khash calc] %s kh/s on any coin with %.1f difficulty and a reward of %.4f coin per block would yield %.4f coins per day" % args
  end
  
  def do_shit_with_numbers(coin, number)
    difficulty_and_reward = Hash.difficulty_and_reward(coin)
    coins = Hash.coins_per_day(difficulty_and_reward, number)

    number_btc = Price.price_of(coin, coins)

    btc_response = Bitcoin::Call.new
    number_usd = btc_response.last_worth(number_btc)

    args = [number, coin.upcase, difficulty_and_reward[:difficulty], coins, coin.upcase, number_btc, number_usd]
    reply "[khash calc] %s kh/s on %s with %.1f difficulty would yield %.4f %s per day OR %.8f BTC per day OR $%.2f USD per day on average." % args
  end
end

