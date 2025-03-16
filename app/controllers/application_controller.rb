class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :internal_id, :leader_name])
  end

  def fetch_page(default: 1)
    Common::PaginationUtil.page_from_params(params, default_page: default)
  end

  def fetch_per_page(default: 10)
    Common::PaginationUtil.per_page_from_params(params, default_per_page: default)
  end
end
