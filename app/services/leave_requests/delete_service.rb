module LeaveRequests
  class DeleteService < ApplicationService
    attr_reader :leave_request_id

    def initialize(leave_request_id)
      super()
      @leave_request_id = leave_request_id
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error:)
    end

    def process
      leave_request = LeaveRequest.find_by(id: leave_request_id)
      raise(ActiveRecord::RecordNotFound) unless leave_request

      leave_request.delete
    end
  end
end
