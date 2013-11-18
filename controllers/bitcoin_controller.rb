class BitcoinController < Rubot::Controller
  on :connect do
    Scheduler.every "1h" do
      do_shit_aight
    end
  end

  command :btc do
    if message.text.empty?
      do_shit_aight
    else
      do_shit_with_numbers(message.text.split.first.to_f)
    end
  end

  def do_shit_aight
    response = Bitcoin::Call.new

    reply "[bitcoin] 1 BTC = #{response.average_display} -- last price: #{response.last_display}"

    if response.really_good_time_to_buy?
      reply "hey mculp, it's a *really* good time to buy."
    elsif response.good_time_to_buy?
      reply "hey mculp, it's a good time to buy."
    elsif response.SELL_QUICK_WTF_COME_ON?
      reply "hey mculp, it's a good time to sell."
    elsif response.HOLY_FUCKING_SHIT_SELL_NOW?
      reply "hey mculp, it's a *really* good time to sell."
    end
  end

  def do_shit_with_numbers(usd)
    response = Bitcoin::Call.new
    avg = response.average_worth(usd)
    last = response.last_worth(usd)

    reply "#{usd} BTC = #{avg} USD avg | #{last} USD last"
  end
end
