class BitcoinController < Rubot::Controller
  command :btc do
    if message.text.empty?
      do_shit_aight
    else
      do_shit_with_numbers(message.text.split.first.to_f)
    end
  end

  def do_shit_aight
    response = Bitcoin::Call.new

    reply "[bitcoin] 1 BTC = $#{response.last_display} USD"
  end

  def do_shit_with_numbers(usd)
    response = Bitcoin::Call.new
    last = response.last_worth(usd)

    reply "#{usd} BTC = $#{last} USD"
  end
end
