class Settings::LogsController < ApplicationController
  include ActionController::Live

  before_action :authenticate_user!

  def web
    # sample
    response.headers["Content-Type"] = "text/event-stream"
    10.times {
      response.stream.write("event: push\n")
      response.stream.write("data: Hello World!!\n")
      sleep 5
    }
  rescue IOError
    logger.info "Stream closed"
  ensure
    response.stream.close
  end

  def recorder
  end

  def worker
  end

end
