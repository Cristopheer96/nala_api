module Users
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
      users = User.select(:id, :name, :email, :internal_id, :leader_name)
                  .paginate(page: @page, per_page: @per_page)
      {
        users:,
        pagination: {
          current_page: users.current_page,
          total_pages: users.total_pages,
          total_entries: users.total_entries
        }
      }
    end
  end
end
