require 'sentimental'

Sentimental.load_defaults

class Darkness
  HISTORY = 150

  HUMANIZATIONS = [
    [-1, "Wow things must be really bad"],
    [-0.5, "It's looking pretty dark in here"],
    [-0.1, "A hint of darkness"],
    [0, "Wow things are pretty neutral"],
    [0.1, "OMG things are kind of positive in here"],
    [0.5, "WTF you guys must be poppin mollys"]
  ]

  class << self

    def log
      @log ||= []
    end

    def spy(message)
      log.push message.text
      log.shift if log.length > HISTORY
    end

    def score
      analyzer = Sentimental.new
      analyzer.get_score log.join(' ')
    end

    # TODO - ugly
    def humanized_score
      s = score
      HUMANIZATIONS.each do |h|
        val, statement = h
        if s < val
          return "#{s} : #{statement}"
        end
      end
      "#{s} : #{HUMANIZATIONS.last.last}"
    end

    def clear
      log.clear
    end

  end
end
