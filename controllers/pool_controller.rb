class PoolController < Rubot::Controller
  BLOCK_SUBSCRIBED_CHANNELS = ["#sfs", "#chunky"]
  STATUS_SUBSCRIBED_CHANNELS = ["#chunky"]

  on :connect do
    Scheduler.every "1m" do
      check_for_new_block
    end

    Scheduler.every "15m" do
      pool_status
    end
  end

  command :pool do
    # - diff, difficulty
    # - avgtime
    # - lastblock
    # - stats
    # - help

    pool_status
  end

  def pool_status
    status = Pool.pool_status

    messages =  ["HASH RATE: #{status[:hash_rate]} MH/s."]
    messages << ["WORKERS: #{status[:number_of_workers]}."]
    messages << ["DIFFICULTY: #{status[:difficulty]}."]
    messages << ["AVERAGE BLOCK TIME: %d hours, %d minutes." % status[:average_block_time]]
    messages << ["TIME SINCE LAST BLOCK: %d hours, %d minutes." % status[:time_since_last_block]]

    STATUS_SUBSCRIBED_CHANNELS.each do |channel|
      server.message channel, "[pool notice] " + messages.join(" ")
    end
  end

  def check_for_new_block
    if block = Pool.check_for_new_block
      msg = "[pool notice] BLOCK FOUND. REWARD: #{block[:reward]}."

      if block[:worker] == 'unknown'
        Scheduler.in "1m" do
          unless Pool.check_for_new_block
            block_info = Pool.block_info

            BLOCK_SUBSCRIBED_CHANNELS.each do |channel|
              server.message channel, "[pool notice] PREVIOUS BLOCK FOUND BY: #{block_info[:found_by]}."
            end
          end
        end
      end

      BLOCK_SUBSCRIBED_CHANNELS.each do |channel|
        if block[:worker] == 'unknown'
          server.message channel, msg
        else
          server.message channel, msg + " FOUND BY: #{block[:found_by]}. SHARES: #{block[:shares]}."
        end
      end
    end
  end
end
