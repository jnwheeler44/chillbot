class PoolController < Rubot::Controller
  SUBSCRIBED_CHANNELS = ["#sfs", "#chunky"]

  on :connect do
    Scheduler.every "1m" do
      check_for_new_block
    end
  end

  def check_for_new_block
    if block = Pool.check_for_new_block
      msg = "[pool notice] BLOCK FOUND. REWARD: #{block[:reward]}. FOUND BY: #{block[:found_by]}. SHARES: #{block[:shares]}"

      SUBSCRIBED_CHANNELS.each do |channel|
        server.message channel, msg
      end
    end
  end
end
