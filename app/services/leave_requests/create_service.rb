module LeaveRequests
  class CreateService < ApplicationService
    attr_reader :user, :params

    def initialize(user, params)
      super()
      @user = user
      @params = params
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error:)
    end

    private

    def process
      return response(error: 'Usuario no autenticado') unless user

      user.leave_requests.create!(params)
    end
  end
end
