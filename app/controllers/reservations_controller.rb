class ReservationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_status_param, only: %w(index)

  def index
    @search = Reservation.ransack(params[:q])
    if @search.sorts.empty?
      case @status
      when :recorded
        @search.sorts = 'program_start_at desc'
      else
        @search.sorts = 'program_start_at asc'
      end
    end
    @reservations = @search.result.where(status: @status).page(params[:page]).per(params[:per])
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy!
    flash[:success] = t('.flash.success')
    redirect_to action: :index and return
  end

  private
  def set_status_param
    @status = params[:status].present? ? params[:status].intern : :reserved
  end

end
