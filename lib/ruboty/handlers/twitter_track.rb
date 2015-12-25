module Ruboty
  module Handlers
    class TwitterTrack < Base
      on(/twitter track by (?<term>.+)\z/,
        name: 'track',
        description: 'Track the twitter stream by the certain term.')

      on(/twitter untrack by (?<term>.+)\z/,
        name: 'untrack',
        description: 'Untrack the twitter stream by the certain term.')

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
          words = term.strip.split(/\s+/).sort
          cache[:terms].push(words).uniq!
        end

        begin
          @stream.restart(cache[:message], cache[:terms])
          message.reply("Done.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def untrack(message)
        cache[:message] = message.original.except(:robot)

        message[:term].split(',').each do |term|
          words = term.strip.split(/\s+/).sort
          cache[:terms].delete(words)
        end

        begin
          @stream.restart(cache[:message], cache[:terms])
          message.reply("Done.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def tracking(message)
        if cache[:terms].empty?
          message.reply("Tracking no terms.")
        else
          cache[:terms].each { |words| message.reply(words.join(' '), code:true) }
        end
      end

      def cache
        unless robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
          status = { message: nil, terms: [] }
          robot.brain.data[Ruboty::TwitterTrack::NAMESPACE] = status
        end

        robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
      end
    end
  end
end
