class BitcoinController < Rubot::Controller
  on :connect do
    Scheduler.every "1h" do
      server.message "#iz", "[bitcoin] 1 BTC = $#{MtGox.ticker.sell}"
    end
  end

  command :btc do
    reply "[bitcoin] 1 BTC = $#{MtGox.ticker.sell}"
  end
end