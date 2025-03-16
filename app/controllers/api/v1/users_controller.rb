module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def list
        result = Users::ListService.call(page: fetch_page, per_page: fetch_per_page)
        raise(result.error) unless result.success?

        render json: result.payload, status: :ok
      end
    end
  end
end
