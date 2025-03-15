module LeaveRequests
  class ImportRowService < ApplicationService
    def initialize(row, row_index)
      super()

      @row = row
      @row_index = row_index
    end

    def call
      user = User.find_by(email: @row['email'])
      user ||= User.create!(user_params)

      user.leave_requests.create!(leave_requests_params)
      true
    rescue StandardError => e
      raise StandardError, "Error con el Usuario #{@row['email']}: #{e.message}"
    end

    private

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
        leave_type: @row['tipo'],
        status: @row['estado'],
        start_date: Date.parse(@row['fecha desde'].to_s),
        end_date: Date.parse(@row['fecha hasta'].to_s),
        notes: @row['motivo']
      }
    end
  end
end
