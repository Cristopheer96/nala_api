module Common
  module PaginationUtil
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 10

    public_constant :DEFAULT_PAGE
    public_constant :DEFAULT_PER_PAGE

    def self.page_from_params(params = {}, default_page: DEFAULT_PAGE)
      fetched = params_with_indifferent_access(params).fetch(:page, default_page)
      fetched.to_i.positive? ? fetched.to_i : default
    end

    def self.per_page_from_params(params = {}, default_per_page: DEFAULT_PER_PAGE)
      fetched = params_with_indifferent_access(params).fetch(:per_page, default_per_page)
      fetched.to_i.positive? ? fetched.to_i : default
    end

    def self.params_with_indifferent_access(params)
      case params
      when ActionController::Parameters
        params.to_unsafe_h.with_indifferent_access
      else
        params.to_h.with_indifferent_access
      end
    end
  end
end
