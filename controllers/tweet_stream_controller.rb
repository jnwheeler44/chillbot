require 'set'
require 'yajl'
require 'tweetstream'

class TweetStreamController < Rubot::Controller

  command :tweetstream do
    case
    when message.text.match(/^following/)
      screen_names = Tweeple.by_channel(message.to)
      reply "Following in #{message.to}: #{screen_names.empty? ? 'nobody! :/' : screen_names.join(', ')}"
    when message.text.match(/^tracking/)
      reply "Tracking: #{TwitterKeywords.keywords.join(', ')}"
    when track = message.text.sub!(/^track/, '')
      track.strip!
      if TwitterKeywords.find_or_create(:keyword => track)
        reply "Tracking: #{TwitterKeywords.keywords.join(', ')}"
      end
    when untrack = message.text.sub!(/^untrack/, '')
      untrack.strip!
      if keyword = TwitterKeywords.find(:keyword => untrack)
        keyword.destroy
        reply "'No longer tracking #{untrack}'. Tracking: #{TwitterKeywords.keywords.join(', ')}"
      else
        reply "Not Tracking #{untrack}"
      end
    when follow = message.text.sub!(/^follow/, '')
      if user = TweetStreamer.instance.get_user(follow)
        Tweeple.find_or_create(:twitter_id => user.id, :screen_name => user.screen_name, :channel => message.to)
        reply "Following in #{message.to}: #{Tweeple.by_channel(message.to).join(', ')}"
      else
        reply "User #{follow} not found."
      end
    when message.text.match(/^unfollow_all/)
      Tweeple.dataset.delete
      reply "UNFOLLOWING ALL FOLLOWBROS"
    when remove = message.text.sub!(/^unfollow/, '')
      if user = TweetStreamer.instance.get_user(remove)
        Tweeple[user.id].destroy
        reply "Unfollowed #{remove.strip}."
      end
    when message.text.match(/^start/)
      TweetStreamer.instance.start do |message|
        if message.text !~ /^RT( |:)/
          if tweep = Tweeple.find(screen_name: message.user.screen_name) and channel = tweep.channel
            server.message channel, "\u0002@#{message.user.screen_name}: \u0002\u0016#{message.text}"
          elsif message.text[0] == "@" && tweep = Tweeple.find(screen_name: message.text.split.first[1..-1]) and channel = tweep.channel
            server.message channel, "\u0002@#{message.user.screen_name}: \u0002\u0016#{message.text}"
          else
            reply "\u0002@#{message.user.screen_name}: \u0002\u0016#{message.text}"
          end
        end
      end
      reply "Tweeter Starting..."
    when message.text.match(/^stop/)
      TweetStreamer.instance.stop
      reply "Tweeter Stopping..."
    end
  end  
end
