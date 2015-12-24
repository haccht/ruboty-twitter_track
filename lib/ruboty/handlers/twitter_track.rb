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
        @stream.start(tracking_terms)
      end

      def track(message)
        message[:term].split(',').map { |e| e.strip }.each do |term|
          if tracking_terms.include?(term)
            message.reply("Already trackedd '#{term}'.")
          else
            tracking_terms << term
            message.reply("Tracked '#{term}'.")
          end
        end

        begin
          @stream.restart(tracking_terms)
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def untrack(message)
        message[:term].split(',').map { |e| e.strip }.each do |term|
          if tracking_terms.include?(term)
            tracking_terms.delete(term)
            message.reply("Untracked '#{term}'.")
          else
            message.reply("'#{term}' has not tracked.")
          end
        end

        begin
          @stream.restart(tracking_terms)
        rescue Twitter::Error::Forbidden
          message.reply("Unable to verify your credentials.")
        end
      end

      def tracking(message)
        if tracking_terms.empty?
          message.reply("tracking no terms.")
        else
          tracking_terms.each { |term| message.reply(term, code:true) }
        end
      end

      def tracking_terms
        robot.brain.data[Ruboty::TwitterTrack::NAMESPACE] ||= []
      end
    end
  end
end
