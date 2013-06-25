require 'twitter'

class TwitterUtil

  def self.find_by_status(status_id)
    initialize_twitter

    if status = @twitter_client.status(status_id)
      text = CGI.unescapeHTML(status.text.gsub("\n", ' - '))
      "\x02@#{status.user.screen_name}\x02: \x16#{text}\x16"
    end
  end

  def self.initialize_twitter
    return if @twitter_client

    config_yaml = YAML.load_file "twitter.yml"
    Twitter.configure do |config|
      config.consumer_key       = config_yaml["consumer_key"]
      config.consumer_secret    = config_yaml["consumer_secret"]
      config.oauth_token        = config_yaml["oauth_token"]
      config.oauth_token_secret = config_yaml["oauth_token_secret"]
    end

    @twitter_client ||= Twitter::Client.new
  end
end
