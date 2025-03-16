module DateRangeCalculator
  def calculate_date_range
    today = Date.today
    @start_date ||= today.beginning_of_year
    @end_date   ||= today.end_of_day
  end
end
