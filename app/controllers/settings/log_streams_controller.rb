class Settings::LogStreamsController < ApplicationController
  include ActionController::Live

  before_action :authenticate_user!

  def web
    response.headers["Content-Type"] = "text/event-stream"
    filename = "#{Rails.root}/log/#{Rails.env}.log"
    File.open(filename) do |log|
      log.extend(File::Tail)
      log.interval = 1
      log.backward(100)
      log.tail { |line|
        sent_stream line.gsub(/\e\[(\d+)m/, '')
      }
    end

  rescue => e
    response.stream.close
    logger.info "Stream closed: #{e}"
  ensure
    response.stream.close
    logger.info "Stream closed"
  end

  private
  def sent_stream(line)
    response.stream.write("event: message\n")
    response.stream.write("data: #{line}\n\n")
  end

end
