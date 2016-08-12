#encoding:UTF-8

require "yaml"
require "active_record"
require "twitter"
require "time"

DBCONF_FILE = "./db/config/database.yml"

dbconf = YAML.load_file(DBCONF_FILE)
ActiveRecord::Base.establish_connection(
  dbconf["development"]
)

class Tweet < ActiveRecord::Base
end

class TwtrStream
  def initialize(keywords)
    @twtr = Twitter::Streaming::Client.new do |config|
      config.consumer_key        ||=\
        ENV["TWITTER_CONSUMER_KEY"];
      config.consumer_secret     ||=\
        ENV["TWITTER_CONSUMER_SECRET"];
      config.access_token        ||=\
        ENV["TWITTER_ACCESS_TOKEN"];
      config.access_token_secret ||=\
        ENV["TWITTER_ACCESS_TOKEN_SECRET"];
    end
    @Keywords = keywords
  end

  def track(keywords=@Keywords)
    cond = {track: keywords.join(","), lang: 'ja'}
    @twtr.filter(cond) do |object|
      puts object.user.name
      puts object.text if object.is_a?(Twitter::Tweet)
    end
  end

end

begin
  stream = TwtrStream.new(ARGV)
  stream.track
rescue Timeout::Error,StandardError => e
  p e.class
  #raise e
  sleep(0.1)
  retry
end

