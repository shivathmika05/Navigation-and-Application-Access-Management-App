class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    users = User.all
    render json: users
  end

  # GET /users/:id
  def show
    render json: @user
  end
  
  # POST /users
  def create
    user = User.new(create_user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: ["Email already exists"] }, status: :unprocessable_entity
  end

  # PUT /users/:id
  def update
    user = User.find_by(id: params[:id])
    
    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
  
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      render json: { message: "User and all their permissions deleted successfully" }
    else
      render json: { error: "Failed to delete user" }, status: :unprocessable_entity
    end
  end

  # This is the new action to get user and app permissions
  # GET /users/by_email_with_app/:email/:app_id
  def by_email_with_app
    user = User.find_by(email: params[:email])
    if user
      permission = Permission.find_by(user_id: user.id, application_id: params[:app_id])
      
      if permission
        render json: user.as_json.merge(access_level: access_level_to_string(permission.access_level))
      else
        render json: { error: "Permission not found for user #{user.id} and app #{params[:app_id]}" }, status: :not_found
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end


  private

  def set_user
    if params[:email].present?
      @user = User.find_by(email: params[:email])
    else
      @user = User.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
  
  def create_user_params
    params.require(:user).permit(:name, :email, :is_admin)
  end

  def user_params
    params.require(:user).permit(:name, :is_admin)
  end

  def access_level_to_string(level)
    case level
    when 1
      "read"
    when 2
      "read, write"
    when 3
      "read, write, delete"
    else
      "unknown"
    end
  end

end
