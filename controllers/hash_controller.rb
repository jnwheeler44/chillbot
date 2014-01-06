class HashController < Rubot::Controller
  command :khash, :perday do
    args = message.text.split

    if args.size == 2
      do_shit_with_numbers(args[0], args[1])
    else
      reply "usage: !khash [coin] [khash]"
    end
  end

  def do_shit_with_numbers(coin, number)
    difficulty_and_reward = Hash.difficulty_and_reward(coin)
    coins = Hash.coins_per_day(difficulty_and_reward, number)

    args = [number, coin.upcase, difficulty_and_reward[:difficulty], coins]
    reply "[khash calc] %s kh/s on %s with %s difficulty would yield %s coins per day on average." % args
  end
end

