class Settings::LogsController < ApplicationController

  before_action :authenticate_user!

  def index
    @target = params[:target].present? ? params[:target].intern : :web
  end

end
