class PoolController < Rubot::Controller
  SUBSCRIBED_CHANNELS = ["#sfs", "#chunky"]

  on :connect do
    Scheduler.every "1m" do
      check_for_new_block
    end
  end

  command :pool do
    # - diff, difficulty
    # - avgtime
    # - lastblock
    # - stats
    # - help
  end

  def check_for_new_block
    if block = Pool.check_for_new_block
      msg = "[pool notice] BLOCK FOUND. REWARD: #{block[:reward]}."

      if block[:worker] == 'unknown'
        Scheduler.in "1m" do
          unless Pool.check_for_new_block
            block_info = Pool.block_info

            SUBSCRIBED_CHANNELS.each do |channel|
              server.message channel, "[pool notice] PREVIOUS BLOCK FOUND BY: #{block_info[:found_by]}."
            end
          end
        end
      end

      SUBSCRIBED_CHANNELS.each do |channel|
        dis_msg = msg
        dis_msg << " FOUND BY: #{block[:found_by]}. SHARES: #{block[:shares]}." unless block[:worker] == 'unknown'

        server.message channel, dis_msg
      end
    end
  end
end
