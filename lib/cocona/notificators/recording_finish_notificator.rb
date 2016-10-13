module Cocona
  module Notificators
    class RecordingFinishNotificator

      attr_reader :program

      def initialize(program)
        @program = program
      end

      def notify
        notify_web_sticky
        notify_twitter
        notify_web_push
      end

      private

      def notify_web_sticky
        message = {
          title: "録画終了",
          body: "『#{@program.title}』を録画しました。",
        }
        WebStickySendingJob.perform_later(message.to_json)
      end

      def notify_twitter
        message = {
          body: "『#{@program.title}』を録画しました。",
        }
        TwitterSendingJob.perform_later(message.to_json)
      end

      def notify_web_push
        message = {
          title: "Cocona",
          body: "『#{@program.title}』を録画しました。",
          url: link_url,
        }
        WebPushSendingJob.perform_later(message.to_json)
      end

      def link_url
        routes = Rails.application.routes.url_helpers
        return routes.url_for(
          controller: :dashboards,
          action: :index,
          host: Settings.web.default_url_options[:host] || 'localhost',
          port: Settings.web.default_url_options[:port] || nil,
          protocol: Settings.web.default_url_options[:protocol] || nil,
          only_path: false,
        )
      end

    end
  end
end
