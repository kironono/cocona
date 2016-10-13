class EpgUpdateJob < ApplicationJob
  queue_as :recorder

  def perform
    Channel.all.each do |channel|
      logger.info "Epg update name: #{channel.name} channel: #{channel.channel}"
      epg_update = Cocona::EpgUpdate.new(channel)
      epg_update.exec
    end
    ReservationUpdateJob.perform_later
  end
end
