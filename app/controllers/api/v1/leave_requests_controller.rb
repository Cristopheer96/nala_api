module Api
  module V1
    class LeaveRequestsController < ApplicationController
      before_action :authenticate_user!, except: :healthcheck

      def import
        render json: { error: 'No se adjuntó ningún archivo.' }, status: :bad_request and return if params[:file].nil?

        file = params[:file]
        result = LeaveRequests::ImportUseCase.call(file)
        return render json: result.error, status: :unprocessable_entity unless result.success?

        render json: result.payload, status: :ok
      end

      def index
        result = LeaveRequests::ListService.call(page: fetch_page, per_page: fetch_per_page)
        return render json: result.error, status: :unprocessable_entity unless result.success?

        render json: result.payload, status: :ok
      end

      def create
        result = LeaveRequests::CreateService.call(current_user, leave_request_params)
        return render json: result.error, status: :unprocessable_entity unless result.success?

        render json: result.payload, status: :created
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
          params.require(:leave_request).permit(:leave_type, :start_date, :end_date, :notes)
        end
    end
  end
end
