class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update, :destroy]

  # GET /applications
  def index
    applications = Application.order(:id)
    render json: { applications: applications }
  end

  # GET /applications/:id
  def show
    render json: @application
  end

  # GET /permissions/:user_id/apps/:app_id
  def get_app_permissions
    user_id = params[:user_id]
    app_id = params[:app_id]

    permission = Permission.find_by(user_id: user_id, application_id: app_id)

    if permission
      access_level = permission.access_level
      render json: { permission: permission, access_level: access_level }
    else
      render json: { error: "Permission not found for user #{user_id} and app #{app_id}" }, status: :not_found
    end
  end

  # POST /applications
  def create
    app = Application.new(create_application_params)
    if app.save
      render json: app, status: :created
    else
      render json: { errors: app.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /applications/:id
  def update
    if @application.update(update_application_params)
      render json: @application
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:id
  def destroy
    if @application.destroy
      render json: { message: "Application '#{@application.name}' deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete application" }, status: :unprocessable_entity
    end
  end

  private

  def set_application
    @application = Application.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Application not found" }, status: :not_found
  end

  def create_application_params
    params.require(:application).permit(:name, :description, :app_url)
  end

  def update_application_params
    params.require(:application).permit(:name, :app_url)
  end
end
