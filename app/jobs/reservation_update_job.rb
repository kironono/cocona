class ReservationUpdateJob < ApplicationJob
  queue_as :general

  def perform
    ReserveRule.where(status: :active).all.each do |reserve_rule|
      reserve(reserve_rule)
    end
  end

  def reserve(reserve_rule)
    ActiveRecord::Base.transaction do
      programs = Program.search({combinator: :and, groupings: reserve_rule.conditions}) \
        .result(distinct: true).includes(:channel_service).joins(:channel_service) \
        .where("start_at >= ?", Time.now).all
      programs.each do |program|
        reservation = Reservation.where(program_id: program.id).first
        unless reservation.present?
          reservation = Reservation.new(
            program_id: program.id,
            reserve_method: :auto,
          )
          reservation.save!
          Cocona::Notificators::ReservationReservedNotificator.new(reservation).notify
        end
      end
    end
  end

end
