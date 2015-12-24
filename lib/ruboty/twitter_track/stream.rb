require 'tweetstream'

module Ruboty
  module TwitterTrack
    class Stream

      def initialize(robot)
        TweetStream.configure do |config|
          config.consumer_key       = CONSUMER_KEY
          config.consumer_secret    = CONSUMER_SECRET
          config.oauth_token        = ACCESS_TOKEN
          config.oauth_token_secret = ACCESS_TOKEN_SECRET
          config.auth_method        = :oauth
        end

        @robot  = robot
        @client = TweetStream::Client.new

        @client.on_inited do
          log(:info , "Connected to twitter stream.")

          # Every day reconnect the stream to prevent from shutdown.
          EM::PeriodicTimer.new(60 * 60 * 24) do
            @client.stream.immediate_reconnect
          end
        end

        @client.on_reconnect do |timeout, retrial|
          log(:info , "Reconnected to twitter stream: #{timeout} sec.")
        end

        @client.on_error do |message|
          log(:error, message)
        end
      end

      def start(message, terms)
        return if terms.empty?

        Thread.start do
          @client.track(*terms) do |object|
            message = Message.new(message.merge(robot: @robot))
            message.reply(u(object))
          end
        end
      end

      def restart(message, terms)
        return start(message, terms) unless @client.stream

        @client.stream.update(params: {:track => terms.keys.join(',')})
      end

      private
      def u(object)
        "https://twitter.com/#{object.user.screen_name}/status/#{object.id}"
      end

      def log(level, message)
        Ruboty.logger.send(level, "[#{Time.now}] ruboty-twitter_track: #{message}")
      end
    end
  end
end
