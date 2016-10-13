module Cocona
  module Notificators
    class RecordingStandbyNotificator

      attr_reader :program

      def initialize(program)
        @program = program
      end

      def notify
        notify_web_sticky
      end

      private

      def notify_web_sticky
        message = {
          title: "まもなく録画開始",
          body: "『#{@program.title}』の録画をまもなく開始します。",
        }
        WebStickySendingJob.perform_later(message.to_json)
      end

    end
  end
end
