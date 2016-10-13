class RecordingKickJob < ApplicationJob
  queue_as :general

  def perform
    start_at = Time.now + 60.seconds
    standby_reservations = Reservation.joins(:program) \
      .where(status: :reserved) \
      .where("programs.start_at <= ?", start_at).all
    standby_reservations.each do |reservation|
      reservation.status = :standby
      reservation.save!
      json = {
        reservation_id: reservation.id,
      }.to_json
      RecordingJob.perform_later(json)
      Cocona::Notificators::RecordingStandbyNotificator.new(reservation.program).notify
    end
  end

end
