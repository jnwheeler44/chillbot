class DogecoinController < Rubot::Controller
  command :doge do
    if message.text.empty?
      do_shit_aight
    else
      do_shit_with_numbers(message.text.split.first.to_f)
    end
  end

  def do_shit_aight
    reply "[bitcoin] 1 DOGE = #{Dogecoin.price}"
  end

  def do_shit_with_numbers(number)
    reply "#{number} DOGE = #{Dogecoin.price_of(number)} BTC"
  end
end

