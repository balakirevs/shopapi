module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end

    def create_user_request(uri, attributes = @user_attributes)
      post uri, params: { user: attributes }
    end

    def create_products_request(uri, attributes, user)
      post uri, params: { user_id: user.id, product: attributes }, headers: { 'Authorization' => user.auth_token }
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.shopapi.v#{version}"
    end

    def api_response_format(format = Mime[:json])
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def api_authorization_header(token)
      request.headers['Authorization'] = token
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end
