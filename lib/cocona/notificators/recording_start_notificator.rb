module Cocona
  module Notificators
    class RecordingStartNotificator

      attr_reader :program

      def initialize(program)
        @program = program
      end

      def notify
        notify_web_sticky
        notify_twitter
      end

      private

      def notify_web_sticky
        message = {
          title: "録画開始",
          body: "『#{@program.title}』の録画を開始しました。",
        }
        WebStickySendingJob.perform_later(message.to_json)
      end

      def notify_twitter
        message = {
          body: "『#{@program.title}』の録画を開始しました。",
        }
        TwitterSendingJob.perform_later(message.to_json)
      end

    end
  end
end
