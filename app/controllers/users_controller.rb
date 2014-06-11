class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new permitted_params
    if @user.save

    else

    end
    redirect_to :index
  end

  private

  def permitted_params
    params.require(:user).permit(:email, :password, :name)
  end
end
