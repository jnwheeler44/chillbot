class LitecoinController < Rubot::Controller
  command :ltc do
    if message.text.empty?
      do_shit_aight
    else
      do_shit_with_numbers(message.text.split.first.to_f)
    end
  end

  def do_shit_aight
    response = Litecoin::Call.new

    reply "[litecoin] 1 LTC = #{response.last_display} | 24hr avg: #{response.average_display}"
  end

  def do_shit_with_numbers(usd)
    response = Litecoin::Call.new
    avg = response.average_worth(usd)
    last = response.last_worth(usd)

    reply "#{usd} LTC = #{last} USD"
  end
end
