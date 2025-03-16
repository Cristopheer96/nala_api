module LeaveRequests
  class ImportRowService < ApplicationService
    def initialize(row, row_index)
      super()

      @row = row
      @row_index = row_index
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error:)
    end

    private

    def process
      user = User.find_by(email: @row['email'])
      user ||= User.create!(user_params)

      user.leave_requests.create!(leave_requests_params)
    end

    def user_params
      {
        name: @row['nombre'],
        email: @row['email'],
        password: @row['email'],
        internal_id: @row['user id'],
        leader_name: @row['lider']
      }
    end

    def leave_requests_params
      {
        leave_type: @row['tipo'].downcase,
        status: @row['estado'].downcase,
        start_date: Date.parse(@row['fecha desde'].to_s),
        end_date: Date.parse(@row['fecha hasta'].to_s),
        notes: @row['motivo']
      }
    end
  end
end
