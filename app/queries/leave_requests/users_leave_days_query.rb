module LeaveRequests
  class UsersLeaveDaysQuery < ApplicationQuery
    include DateRangeCalculator

    def initialize(filters = {})
      super()
      @leader_name = filters[:leader_name]
      @name        = filters[:name]
      @start_date  = filters[:start_date] ? Date.parse(filters[:start_date]) : nil
      @end_date    = filters[:end_date] ? Date.parse(filters[:end_date]) : nil
      @page     = filters[:page]
      @per_page = filters[:per_page]
      @order_by = filters[:order_by] || 'u.name'
      @order_direction = filters[:order]&.downcase == 'desc' ? 'DESC' : 'ASC'

      calculate_date_range if @start_date.nil? || @end_date.nil?
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error: error.message)
    end

    private

    def raw_query
      user_conditions = []
      user_conditions << "u.leader_name ILIKE '%#{@leader_name}%'" if @leader_name.present?
      user_conditions << "u.name ILIKE '%#{@name}%'" if @name.present?
      where_clause = user_conditions.empty? ? "1=1" : user_conditions.join(" AND ")

      join_conditions = []
      join_conditions << "lr.status = 'aprobado'"
      join_conditions << "lr.end_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      join_conditions << "lr.start_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      join_clause = join_conditions.join(" AND ")
      offset = (@page - 1) * @per_page
      allowed_order_by = ['u.name', 'u.leader_name', 'total_days']
      order_by_clause = allowed_order_by.include?(@order_by) ? @order_by : 'u.name'


      <<-SQL.squish
        SELECT u.id,
               u.name,
               u.leader_name,
               COALESCE(SUM(
                 CASE
                   WHEN lr.start_date IS NOT NULL THEN
                     (LEAST(lr.end_date, '#{@end_date.strftime('%Y-%m-%d')}') -
                      GREATEST(lr.start_date, '#{@start_date.strftime('%Y-%m-%d')}')) + 1
                   ELSE 0
                 END
               ), 0) AS total_days
        FROM users u
        LEFT JOIN leave_requests lr ON lr.user_id = u.id AND #{join_clause}
        WHERE #{where_clause}
        GROUP BY u.id, u.name, u.leader_name
        ORDER BY #{order_by_clause} #{@order_direction}
        LIMIT #{@per_page} OFFSET #{offset}
      SQL
    end

    def process
      query_string = raw_query
      result = ActiveRecord::Base.connection.execute(query_string)
      total = count_total_records

      { query: result, range: { start_date: @start_date, end_date: @end_date },
        page: @page, per_page: @per_page, total: total }
    end

    def count_total_records
      user_conditions = []
      user_conditions << "u.leader_name ILIKE '%#{@leader_name}%'" if @leader_name.present?
      user_conditions << "u.name ILIKE '%#{@name}%'" if @name.present?
      where_clause = user_conditions.empty? ? "1=1" : user_conditions.join(" AND ")

      join_conditions = []
      join_conditions << "lr.status = 'aprobado'"
      join_conditions << "lr.end_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      join_conditions << "lr.start_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      join_clause = join_conditions.join(" AND ")

      count_sql = <<-SQL.squish
        SELECT COUNT(*) AS total_count FROM (
          SELECT u.id
          FROM users u
          LEFT JOIN leave_requests lr ON lr.user_id = u.id AND #{join_clause}
          WHERE #{where_clause}
          GROUP BY u.id
        ) subquery
      SQL

      result = ActiveRecord::Base.connection.execute(count_sql)
      result.first["total_count"].to_i
    end
  end
end
