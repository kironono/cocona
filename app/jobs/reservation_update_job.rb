class ReservationUpdateJob < ApplicationJob
  queue_as :general

  def perform
    ReserveRule.where(status: :active).all.each do |reserve_rule|
      reserve(reserve_rule)
    end
  end

  def reserve(reserve_rule)
    ActiveRecord::Base.transaction do
      reservation_created = false
      programs = Program.search({combinator: :and, groupings: reserve_rule.conditions}) \
        .result(distinct: true).includes(:channel_service).joins(:channel_service) \
        .where("start_at >= ?", Time.now).all
      programs.each do |program|
        reservation = Reservation.where(program_id: program.id).first
        unless reservation.present?
          reservation_created = true
          reservation = Reservation.new(
            program_id: program.id,
            reserve_method: :auto,
          )
          reservation.save!
          Cocona::Notificators::ReservationReservedNotificator.new(reservation).notify
        end
      end

      if reservation_created
        reserve_rule.last_reserved_at = Time.now
        reserve_rule.save!
      end
    end
  end

end
