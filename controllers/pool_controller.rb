class PoolController < Rubot::Controller
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

  command :multiport do
    status = Pool.multiport_status
    reply "[pool notice] MULTIPORT: %s. WORKERS: %s. %s HASH RATE: %s MH/s" % [status[:coin], status[:workers], status[:coin], status[:rate]]
  end

  def pool_status(coin = :doge)
    status = Pool.new(coin).pool_status(uncached: true)

    messages =  ["HASH RATE: #{status[:hash_rate]} MH/s."]
    messages << ["WORKERS: #{status[:number_of_workers]}."]
    messages << ["DIFFICULTY: #{status[:difficulty]}."]
    messages << ["AVERAGE BLOCK TIME: %d hours, %d minutes." % status[:average_block_time]]
    messages << ["TIME SINCE LAST BLOCK: %d hours, %d minutes." % status[:time_since_last_block]]

    reply "[#{coin} pool notice] " + messages.join(" ")
  end
end
