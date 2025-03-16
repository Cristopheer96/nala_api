module Api
  module V1
    class LeaveRequestsController < ApplicationController
      before_action :authenticate_user!, except: :healthcheck

      def import
        if params[:file].nil?
          render json: { error: 'No se adjuntó ningún archivo.' }, status: :bad_request and return
        end

        result = LeaveRequests::ImportUseCase.call(params[:file])
        render_service_response(result)
      end

      def index
        result = LeaveRequests::ListService.call(page: fetch_page, per_page: fetch_per_page)
        render_service_response(result)
      end

      def create
        result = LeaveRequests::CreateService.call(current_user, leave_request_params)
        render_service_response(result, success_status: :created)
      end

      def update
        result = LeaveRequests::UpdateService.call(params[:id].to_i, leave_request_params)
        render_service_response(result)
      end

      def destroy
        result = LeaveRequests::DeleteService.call(params[:id].to_i)
        render_service_response(result)
      end

      # TODO: Remove this acton
      def healthcheck
        if User.all.empty?
          render json: { message: 'holaaa No hay ningun usuario'}, status: :ok
        else
          render json: User.all, status: :ok
        end
      end

      private

        def leave_request_params
          params.require(:leave_request).permit(:leave_type, :start_date, :end_date, :notes, :status)
        end

        def render_service_response(result, success_status: :ok)
          if result.success?
            render json: result.payload, status: success_status
          else
            render json: result.error, status: :unprocessable_entity
          end
        end
    end
  end
end
