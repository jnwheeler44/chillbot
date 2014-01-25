class PoolController < Rubot::Controller
  BLOCK_SUBSCRIBED_CHANNELS = ["#sfs", "#chunky"]
  STATUS_SUBSCRIBED_CHANNELS = ["#chunky"]

  on :connect do
    Pool::POOLS.keys.each do |pool|
      Scheduler.every "1m" do
        check_for_new_block pool
      end
    end
  end

  command :pool do
    # - diff, difficulty
    # - avgtime
    # - lastblock
    # - stats
    # - help

    if coin = message.text.strip and !coin.empty?
      pool_status coin.to_sym
    else
      pool_status
    end
  end

  def pool_status(coin = :doge)
    status = Pool.new(coin).pool_status

    messages =  ["HASH RATE: #{status[:hash_rate]} MH/s."]
    messages << ["WORKERS: #{status[:number_of_workers]}."]
    messages << ["DIFFICULTY: #{status[:difficulty]}."]
    messages << ["AVERAGE BLOCK TIME: %d hours, %d minutes." % status[:average_block_time]]
    messages << ["TIME SINCE LAST BLOCK: %d hours, %d minutes." % status[:time_since_last_block]]

    reply "[#{coin} pool notice] " + messages.join(" ")
  end

  def check_for_new_block(coin)
    pool = Pool.new(coin)

    if block = pool.check_for_new_block
      msg = "[#{coin} pool notice] BLOCK FOUND. REWARD: #{block[:reward]}."

      if block[:worker] == 'unknown'
        Scheduler.in "1m" do
          unless pool.check_for_new_block
            block_info = pool.block_info

            BLOCK_SUBSCRIBED_CHANNELS.each do |channel|
              server.message channel, "[#{coin} pool notice] PREVIOUS BLOCK FOUND BY: #{block_info[:found_by]}."
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
