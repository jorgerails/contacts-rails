module AuthenticationHelper
  def with_api_credentials
    request.headers.merge!({ 'X-API-KEY' => ENV['API_KEY'] })

    yield
  end
end
