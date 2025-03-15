module Api
  module V1
    class LeaveRequestsController < ApplicationController
      before_action :authenticate_user!, except: :healthcheck

      def import
        render json: { error: 'No se adjuntó ningún archivo.' }, status: :bad_request and return if params[:file].nil?

        file = params[:file]
        result = LeaveRequests::ImportUseCase.call(file)
        raise(result.error) unless result.success?

        render json: result.payload, status: :ok
      end

      # TODO: Remove this acton
      def healthcheck
        if User.all.empty?
          render json: { message: 'holaaa No hay ningun usuario'}, status: :ok
        else
          render json: User.all, status: :ok
        end
      end
    end
  end
end
