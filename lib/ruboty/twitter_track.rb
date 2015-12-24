require 'ruboty'
require 'ruboty/twitter_track/stream'
require 'ruboty/handlers/twitter_track'

module Ruboty
  module TwitterTrack
    NAMESPACE = 'twitter_track'

    CONSUMER_KEY        = ENV['CONSUMER_KEY']
    CONSUMER_SECRET     = ENV['CONSUMER_SECRET']
    ACCESS_TOKEN        = ENV['ACCESS_TOKEN']
    ACCESS_TOKEN_SECRET = ENV['ACCESS_TOKEN_SECRET']
  end
end
