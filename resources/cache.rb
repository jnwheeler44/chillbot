class Cache
  def initialize
    @memory = {}
    @expires = {}
  end

  def get(request)
    return unless @expires[request]

    if Time.now - @expires[request] > 900
      @memory.delete(request)
      nil
    else
      puts "cache hit for #{request}"
      @memory[request]
    end
  end

  def set(request, response)
    @expires[request] = Time.now
    @memory[request] = response
  end
end

