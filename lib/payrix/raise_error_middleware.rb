module Payrix
# RaiseError is a Faraday middleware that raises exceptions on common HTTP
# Inspired/referenced from Faraday RaiseError middleware
  # client or server error responses.
  class RaiseErrorMiddleware < Faraday::Middleware
    # rubocop:disable Naming/ConstantName
    ClientErrorStatuses = (400...500).freeze
    ServerErrorStatuses = (500...600).freeze
    # rubocop:enable Naming/ConstantName

    def on_complete(env)
      case env[:status]
      when 400
        raise Payrix::BadRequestError, response_values(env)
      when 401
        raise Payrix::UnauthorizedError, response_values(env)
      when 403
        raise Payrix::ForbiddenError, response_values(env)
      when 404
        raise Payrix::ResourceNotFound, response_values(env)
      when 407
        # mimic the behavior that we get with proxy requests with HTTPS
        msg = %(407 "Proxy Authentication Required")
        raise Payrix::ProxyAuthError.new(msg, response_values(env))
      when 409
        raise Payrix::ConflictError, response_values(env)
      when 422
        raise Payrix::UnprocessableEntityError, response_values(env)
      when ClientErrorStatuses
        raise Payrix::ClientError, response_values(env)
      when ServerErrorStatuses
        raise Payrix::ServerError, response_values(env)
      when nil
        raise Payrix::NilStatusError, response_values(env)
      end
    end

    def response_values(env)
      {
        status: env.status,
        headers: env.response_headers,
        body: env.body,
        request: {
          method: env.method,
          url: env.url,
          url_path: env.url.path,
          params: query_params(env),
          headers: env.request_headers,
          body: env.request_body
        }
      }
    end

    def query_params(env)
      env.request.params_encoder ||= Faraday::Utils.default_params_encoder
      env.params_encoder.decode(env.url.query)
    end
  end
end

Faraday::Response.register_middleware(raise_error_middleware: Payrix::RaiseErrorMiddleware)
