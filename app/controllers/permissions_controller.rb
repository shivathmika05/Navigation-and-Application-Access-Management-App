class PermissionsController < ApplicationController
  before_action :set_permission, only: [:destroy]
  before_action :set_user, only: [:by_user, :update_by_user]

  # GET /permissions
  def index
    permissions = if params[:user_id].present?
                    Permission.includes(:user, :application)
                              .where(user_id: params[:user_id])
                              .order(:id)
                  else
                    Permission.includes(:user, :application).order(:id)
                  end

    render json: permissions.map { |perm|
      {
        permission_id: perm.id,
        user_name: perm.user.name,
        application_name: perm.application.name,
        description: perm.application.description,
        access_level: perm.access_level
      }
    }
  end

  # GET /permissions/by_user/:user_id
  def by_user
    permissions = Permission.includes(:application).where(user_id: @user.id).map do |permission|
      {
        permission_id: permission.id,
        application_id: permission.application.id,
        application_name: permission.application.name,
        access_level: permission.access_level
      }
    end
    render json: permissions
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found with ID #{params[:user_id]}" }, status: :not_found
  end

  # POST /permissions
  def create
    existing_permission = Permission.find_by(
      user_id: params[:user_id],
      application_id: params[:application_id]
    )

    if existing_permission
      return render json: { error: "Permission for this user and application already exists" },
                    status: :unprocessable_entity
    end

    permission = Permission.new(
      user_id: params[:user_id],
      application_id: params[:application_id],
      access_level: params[:access_level]
    )

    if permission.save
      render json: { message: "Permission created successfully", permission: permission }, status: :created
    else
      render json: { errors: permission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /permissions/update_by_user/:user_id/:app_id
  def update_by_user
    permission = Permission.find_by(user_id: @user.id, application_id: params[:app_id])

    if permission.nil?
      render json: { error: "Permission not found for this user and app" }, status: :not_found
      return
    end

    new_level = params[:access_level].to_i
    unless [1, 2, 3].include?(new_level)
      return render json: { error: "Invalid access level." }, status: :unprocessable_entity
    end

    if permission.update(access_level: new_level)
      render json: { message: "Permission updated successfully", permission: permission }
    else
      render json: { errors: permission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /permissions
  def destroy
    if @permission&.destroy
      render json: { message: "Permission deleted successfully" }
    else
      render json: { error: "Permission not found or could not be deleted" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def set_permission
    @permission = Permission.find_by(user_id: params[:user_id], application_id: params[:application_id])
  end

  def permission_params
    params.require(:permission).permit(:user_id, :application_id, :access_level)
  end
end
