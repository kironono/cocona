module Cocona
  module Notificators
    class ReservationReservedNotificator

      attr_reader :reservation

      def initialize(reservation)
        @reservation = reservation
      end

      def notify
        notify_web_sticky
        notify_twitter
      end

      private
      def notify_web_sticky
        message = {
          title: "予約追加",
          body: "『#{@reservation.program.title}』を予約しました。",
        }
        WebStickySendingJob.perform_later(message.to_json)
      end

      def notify_twitter
        message = {
          body: "『#{@reservation.program.title}』を予約しました。",
        }
        TwitterSendingJob.perform_later(message.to_json)
      end

    end
  end
end
