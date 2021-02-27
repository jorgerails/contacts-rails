class ApplicationController < ActionController::API
  before_action :check_api_key

  private

  def check_api_key
    if request.headers['X-API-KEY'] != ENV['API_KEY']
      render json: 'Wrong API credentials.', status: 400
    end
  end
end
