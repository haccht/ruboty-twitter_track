module Ruboty
  module Handlers
    class TwitterTrack < Base
      on(/twitter track by (?<term>.+)\z/,
        name: 'track',
        description: 'Track the twitter stream with the term.')

      on(/twitter untrack (?<id>\d+)\z/,
        name: 'untrack',
        description: 'Untrack the twitter stream with the term.')

      on(/twitter tracking\z/,
        name: 'tracking',
        description: 'List tracking terms.')

      def initialize(*args)
        super

        @stream = Ruboty::TwitterTrack::Stream.new(robot)
        @stream.start(cache[:message], cache[:terms])
      end

      def track(message)
        cache[:message] = message.original.except(:robot)

        message[:term].split(',').each do |term|
          key   = generate_id
          words = term.strip.split(/\s+/)
          cache[:terms][key] = words
        end

        begin
          @stream.restart(cache[:message], cache[:terms].values)
          message.reply("Tracked '#{message[:term]}'.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def untrack(message)
        cache[:message] = message.original.except(:robot)

        key   = message[:id]
        words = cache[:terms].delete(key)
        unless words
          message.reply("'#{key}' not found.")
          return
        end

        begin
          @stream.restart(cache[:message], cache[:terms].values)
          message.reply("Untracked '#{key}: #{words.join(' ')}'.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def tracking(message)
        if cache[:terms].empty?
          message.reply("Tracking no terms.")
        else
          response = cache[:terms].map { |key, words| "#{key}: #{words.join(' ')}" }
          message.reply(response.join("\n"), code:true)
        end
      end

      def cache
        unless robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
          status = { message: nil, terms: {} }
          robot.brain.data[Ruboty::TwitterTrack::NAMESPACE] = status
        end

        robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
      end

      private
      def generate_id
        id = (100..999).to_a.sample
        cache[:terms][id].nil? ? id : generate_id
      end
    end
  end
end
