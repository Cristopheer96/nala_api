module LeaveRequests
  class ListService < ApplicationService
    def initialize(page:, per_page:)
      super()
      @page = page
      @per_page = per_page
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error:)
    end

    private

    def process
      items = LeaveRequest.includes(:user).paginate(page: @page, per_page: @per_page)
      {
        items: items.map do |leave_request|
          leave_request.attributes.merge(user_name: leave_request.user.name, leader_name: leave_request.user.leader_name)
        end,
        pagination: {
          current_page: items.current_page,
          total_pages: items.total_pages,
          total_entries: items.total_entries
        }
      }
    end
  end
end
