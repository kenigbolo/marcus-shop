class ApplicationController < ActionController::API
  before_action :set_current_user

  private

  def set_current_user
    Current.user_id = request.headers['X-User-ID'] || request.headers['X-Admin-ID']
    render json: { error: 'Missing X-User-ID header' }, status: :unauthorized if Current.user_id.blank?
  end
end
