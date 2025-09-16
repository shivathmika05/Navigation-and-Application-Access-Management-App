class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update, :destroy ]

  def index
    applications = Application.order(:id).page(params[:page]).per(params[:per_page] || 10)

    render json: {
      applications: applications,
      meta: {
        current_page: applications.current_page,
        next_page: applications.next_page,
        prev_page: applications.prev_page,
        total_pages: applications.total_pages,
        total_count: applications.total_count
      }
    }
  end

  def show
    render json: @application
  end

  def create
    app = Application.new(create_application_params)
    if app.save
      render json: app, status: :created
    else
      render json: { errors: app.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @application.update(update_application_params)
      render json: @application
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end

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
    params.require(:application).permit(:name, :description, :app_url, :app_logo)
  end

  def update_application_params
    params.require(:application).permit(:name, :app_url)
  end
end
