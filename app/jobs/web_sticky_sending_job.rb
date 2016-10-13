class WebStickySendingJob < ApplicationJob
  queue_as :general

  def perform(message)
    msg = JSON.parse(message, {symbolize_names: true})
    ActionCable.server.broadcast "notification", msg
  end

end
