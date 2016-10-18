class ReserveRulesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_reserve_rule, only: [:edit, :update, :destroy, :switch_status]

  def index
    @search = ReserveRule.ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @reserve_rules = @search.result.page(params[:page]).per(params[:per])
  end

  def new
    @reserve_rule = ReserveRule.new
    @redraw_json = [].to_json
  end

  def create
    condition = reserve_rule_filter_params.to_json
    @redraw_json = condition
    @reserve_rule = ReserveRule.new(condition: condition)
    if @reserve_rule.save
      flash[:success] = t('.flash.success', id: @reserve_rule.id)
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :new and return
    end
  end

  def edit
    @redraw_json = @reserve_rule.condition
  end

  def update
    condition = reserve_rule_filter_params.to_json
    @redraw_json = condition
    @reserve_rule.condition = condition
    if @reserve_rule.save
      flash[:success] = t('.flash.success', id: @reserve_rule.id)
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :edit and return
    end
  end

  def destroy
    @reserve_rule.destroy
    flash[:success] = t('.flash.success', id: @reserve_rule.id)
    redirect_to action: :index and return
  end

  def switch_status
    if @reserve_rule.status == 'active'
      @reserve_rule.status = 'inactive'
    else
      @reserve_rule.status = 'active'
    end
    if @reserve_rule.save
      render json: {result: "OK", status: @reserve_rule.status} and return
    else
      render json: {result: "NG"} and return
    end
  end

  def reservation_update
    ReservationUpdateJob.perform_later
    flash[:success] = t('.flash.success')
    redirect_to action: :index and return
  end

  private
  def reserve_rule_filter_params
    begin
      return params.require(:filters)
    rescue ActionController::ParameterMissing
      return []
    end
  end

  def set_reserve_rule
    @reserve_rule = ReserveRule.find(params[:id])
  end

end
