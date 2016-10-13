class ServerInfosController < ApplicationController
  before_action :authenticate_user!

  def current_time
    data = {
      epoch_milliseconds: (Time.now.to_f * 1000).ceil
    }
    render json: data and return
  end
end
