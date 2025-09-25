class PermissionsController < ApplicationController
  before_action :set_permission, only: [:destroy_by_user_app]
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
        name: perm.user.name,
        user_id: perm.user.id,
        application_id: perm.application.id,
        app_url: perm.application.app_url,
        is_admin: perm.user.is_admin,
        application_name: perm.application.name,
        description: perm.application.description,
        access_level: access_level_to_string(perm.access_level)
      }
    }
  end

  # GET /permissions/by_user/:user_id
  def by_user
    permissions = Permission.includes(:application).where(user_id: params[:user_id]).map do |permission|
      {
        permission_id: permission.id,
        name: permission.user.name,
        application_id: permission.application.id,
        application_name: permission.application.name,
        description: permission.application.description,
        access_level: access_level_to_string(permission.access_level)
      }
    end
    render json: permissions
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found with ID #{params[:user_id]}" }, status: :not_found
  end



  def user_app_access
    user_id = params[:user_id]
    app_id = params[:app_id]

    permission = Permission.find_by(user_id: user_id, application_id: app_id)

    if permission
      render json: { permission: permission, access_level: permission.access_level }
    else
      render json: { error: "Permission not found for user #{user_id} and app #{app_id}" }, status: :not_found
    end
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
    user = User.find_by(id: params[:user_id])
    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end
    permission = Permission.find_by(user_id: user.id, application_id: params[:app_id])
    if permission.nil?
      render json: { error: "Permission not found for this user and app" }, status: :not_found
      return
    end
    level_map = {
      "read" => 1,
      "read,write" => 2,
      "read,write,delete" => 3
    }
    new_level = level_map[params[:access_level]]
    unless new_level
      return render json: { error: "Invalid access level: '#{params[:access_level]}'. Please use 'read', 'read,write', or 'read,write,delete'." }, status: :unprocessable_entity
    end
    if permission.update(access_level: new_level)
      render json: { message: "Permission updated successfully", permission: permission }
    else
      render json: { errors: permission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /permissions/destroy_by_user_app
  def destroy_by_user_app
    if @permission
      @permission.destroy
      render json: { message: "Permission deleted successfully." }, status: :ok
    else
      render json: { error: "Permission not found." }, status: :not_found
    end
  end

  private

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
