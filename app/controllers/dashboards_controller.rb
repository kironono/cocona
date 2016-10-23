class DashboardsController < ApplicationController

  before_action :authenticate_user!

  def index
    @reserve_rules_active_count = ReserveRule.where(status: :active).count
    @reserve_rules_inactive_count = ReserveRule.where(status: :inactive).count
    @reservations_count = Reservation.where(status: :reserved).count
    @recent_reservations_count = Reservation.where(status: :reserved).joins(:program).where('programs.start_at <= ?', Time.now + 24.hours).count
    @videos_count = Video.count
    @recent_videos_count = Video.where('end_at >= ?', Time.now - 24.hours).count
    @recording_count = Reservation.where(status: :recording).count
    @standby_count = Reservation.where(status: :standby).count
  end

end
