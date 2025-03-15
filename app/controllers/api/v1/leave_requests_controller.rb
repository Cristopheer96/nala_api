module Api
  module V1
    class LeaveRequestsController < ApplicationController
      before_action :authenticate_user!

      def import
        render json: { error: 'No se adjuntó ningún archivo.' }, status: :bad_request and return if params[:file].nil?

        file = params[:file]
        result = LeaveRequests::ImportUseCase.call(file)
        raise(result.error) unless result.success?

        render json: result.payload, status: :ok
      end
    end
  end
end
