class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    user = User.new(create_user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(update_user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: "User and all their permissions deleted successfully" }
    else
      render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def create_user_params
    params.require(:user).permit(:name, :email, :is_admin)
  end

  def update_user_params
    params.require(:user).permit(:name, :is_admin)
  end
end
