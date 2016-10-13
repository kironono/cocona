class ReservationsController < ApplicationController

  before_action :authenticate_user!

  def index
    if params[:status].present?
      @status = params[:status].intern
    else
      @status = :reserved
    end

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

end
