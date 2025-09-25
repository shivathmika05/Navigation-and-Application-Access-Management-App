module Api
    module V1
      class AppEventsController < ApplicationController
        before_action :set_app_event, only: [:update, :destroy, :show]
  
        # GET /api/v1/app_events
        def index
          app_events = AppEvent.all
          render json: app_events
        end
  
        # GET /api/v1/app_events/:id
        def show
          render json: @app_event
        end
  
        # POST /api/v1/app_events
        def create
          app_event = AppEvent.new(event_params)
          if app_event.save
            render json: app_event, status: :created
          else
            render json: { errors: app_event.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT /api/v1/app_events/:id
        def update
          if @app_event.update(event_params)
            render json: @app_event
          else
            render json: { errors: @app_event.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/app_events/:id
        def destroy
          @app_event.destroy
          render json: { message: "Event deleted successfully" }
        end
  
        private
  
        def set_app_event
          @app_event = AppEvent.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "AppEvent not found" }, status: :not_found
        end
  
        def event_params
          params.require(:app_event).permit(:name, :location, :date)
        end
      end
    end
  end
  