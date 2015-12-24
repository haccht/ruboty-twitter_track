module Ruboty
  module Handlers
    class TwitterTrack < Base
      on(/track tweets by (?<term>.+)\z/,
        name: 'track',
        description: 'Track tweets in the twitter stream.')

      on(/untrack tweets by (?<term>.+)\z/,
        name: 'untrack',
        description: 'Untrack tweets in the twitter stream.')

      on(/list tweets tracking\z/,
        name: 'tracking',
        description: 'List tracking tweets in the twitter stream.')

      def initialize(*args)
        super

        @stream = Ruboty::TwitterTrack::Stream.new(robot)
        @stream.start(cache.message, cache.terms)
      end

      def track(message)
        cache.message = message.original.except(:robot)

        message[:term].split(',').each do |term|
          term.strip!
          cache.terms.push(term).uniq!
        end

        begin
          @stream.restart(cache.message, cache.terms)
          message.reply("Done.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def untrack(message)
        cache.message = message.original.except(:robot)

        message[:term].split(',').each do |term|
          term.strip!
          cache.terms.delete(term)
        end

        begin
          @stream.restart(cache.message, cache.terms)
          message.reply("Done.")
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def tracking(message)
        if cache.terms.empty?
          message.reply("Tracking no terms.")
        else
          cache.terms.each { |term| message.reply(term, code:true) }
        end
      end

      def cache
        unless robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
          item = Struct.new('Cache', :message, :terms).new(nil, [])
          robot.brain.data[Ruboty::TwitterTrack::NAMESPACE] = item
        end

        robot.brain.data[Ruboty::TwitterTrack::NAMESPACE]
      end
    end
  end
end
