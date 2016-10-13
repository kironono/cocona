class Settings::UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @search = User.ransack(params[:q])
    @users = @search.result.page(params[:page]).per(params[:per])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('.flash.success')
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :new and return
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = user_params
    if @user.save
      flash[:success] = t('.flash.success')
      redirect_to action: :index and return
    else
      flash.now[:error] = t('.flash.error')
      render action: :edit and return
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = t('.flash.success')
    redirect_to action: :index and return
  end

  private
  def user_params
    p = params.require(:user).permit(User.permit_attrs)
    if p[:password].blank?
      p.delete(:password)
    end
    if p[:password_confirmation].blank?
      p.delete(:password_confirmation)
    end
    p
  end

end
