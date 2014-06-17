class UsersController < ApplicationController
  before_action :authenticate_admin!, except: [:password, :settings]

  def index
    @users = User.all.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new permitted_params
    if @user.save
      flash[:notice] = t 'user.info.created'
    else
      flash[:alert] = t 'user.info.failure'
    end
    redirect_to action: :index
  end

  def settings
  end

  def password
    current_user.password = params[:password]
    current_user.password_confirmation = params[:password_confirmation]
    if current_user.save
      flash[:notice] = t 'user.info.pass_changed'
    else
      flash[:alert] = t 'user.info.failure'
    end
    redirect_to :root
  end

  private

  def permitted_params
    params.require(:user).permit(:email, :password, :name)
  end
end
