class Settings::ChannelsController < ApplicationController

  before_action :authenticate_user!

  def index
    @search = Channel.ransack(params[:q])
    @channels = @search.result.page(params[:page]).per(params[:per])
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)
    if @channel.save
      flash[:success] = t('.flash.success')
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :new and return
    end
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.attributes = channel_params
    if @channel.save
      flash[:success] = t('.flash.success')
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :edit and return
    end
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    flash[:success] = t('.flash.success')
    redirect_to action: :index and return
  end

  private
  def channel_params
    params.require(:channel).permit(Channel.permit_attrs)
  end

end
