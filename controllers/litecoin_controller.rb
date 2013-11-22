class LitecoinController < Rubot::Controller
  on :connect do
    Scheduler.every "1h" do
      do_shit_aight
    end
  end


  command :ltc do
    if message.text.empty?
      do_shit_aight
    else
      do_shit_with_numbers(message.text.split.first.to_f)
    end
  end

  def do_shit_aight
    response = Litecoin::Call.new

    reply "[litecoin] 1 LTC = #{response.average_display} -- last price: #{response.last_display}"
  end

  def do_shit_with_numbers(usd)
    response = Litecoin::Call.new
    avg = response.average_worth(usd)
    last = response.last_worth(usd)

    reply "#{usd} LTC = #{avg} USD avg | #{last} USD last"
  end
end
