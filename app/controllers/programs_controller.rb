class ProgramsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_program, only: [:show, :reserve]

  def index
    @search = Program.where("end_at >= ?", Time.now).ransack(params[:q])
    @search.sorts = 'start_at asc' if @search.sorts.empty?
    @programs = @search.result(distinct: true) \
      .includes(:channel_service).joins(:channel_service) \
      .page(params[:page]).per(params[:per])
  end

  def show
  end

  def reserve
    unless @program.reservations.present?
      @program.reservations.create(reserve_method: "manual")
      RecordingKickJob.perform_later
      render json: {result: 'OK', message: t('.success', title: @program.title)}
    else
      render json: {result: 'NG', message: t('.conflict', title: @program.title)}
    end
  end

  private
  def set_program
    @program = Program.find(params[:id])
  end

end
