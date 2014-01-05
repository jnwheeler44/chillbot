class PriceController < Rubot::Controller
  command :price, :worth do
    args = message.text.split

    if args.size == 2
      do_shit_with_numbers(args[0], args[1])
    elsif args.size == 1
      do_shit_aight(args[0])
    elsif args.first.empty?
      reply "usage: !price [coin] [amount (optional)]"
    end
  end

  def do_shit_aight(coin)
    price = Price.price(coin)
    reply "[#{coin.upcase} price] 1 #{coin.upcase} = #{price} BTC | 1 MEGA#{coin.upcase} = #{1000000 * price.to_f} BTC"
  end

  def do_shit_with_numbers(coin, number)
    number_btc = Price.price_of(coin, number)

    btc_response = Bitcoin::Call.new
    number_usd = btc_response.last_worth(number_btc)

    reply "[#{coin.upcase} price] #{number} #{coin.upcase} = #{number_btc} BTC | #{number} #{coin.upcase} = $#{number_usd} USD"
  end
end

