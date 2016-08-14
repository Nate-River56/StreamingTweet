#encoding:UTF-8

require "yaml"
require "active_record"
require "twitter"
require "time"
require "chatwork"

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
      tweet = Tweet.new(
        :keywords     => keywords,
        :user_id     => object.user.id,
        :screen_name => object.user.screen_name,
        :name        => object.user.name,
        :text        => object.text,
        :posted_at   => object.created_at 
      )
      tweet.save
      puts "UserID: #{object.user.id}"
      puts "UserScName: @#{object.user.screen_name}"
      puts "UserName: #{object.user.name}"
      puts "Tweet: #{object.text}"
      puts "PostAt: #{object.created_at}"
      puts "============================"
    end
  end

end

begin
  stream = TwtrStream.new(ARGV)
  stream.track
rescue Timeout::Error,StandardError => e
  puts "---------------------"
  puts "Exception: #{e.class}"
  puts "---------------------"
  #raise e
  sleep(0.1)
  retry
end

