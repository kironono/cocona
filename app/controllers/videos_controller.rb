class VideosController < ApplicationController

  before_action :authenticate_user!
  before_action :set_video, only: [:show]

  def index
    @search = Video.ransack(params[:q])
    @search.sorts = 'start_at desc' if @search.sorts.empty?
    @videos = @search.result.page(params[:page]).per(params[:per])
  end

  def show
  end

  private
  def set_video
    @video = Video.find(params[:id])
  end

end
