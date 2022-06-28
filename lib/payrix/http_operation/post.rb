module Payrix
  module HttpOperation
    module Post
      def post(params = {}, timeout=nil)
        set(params)

        headers = build_headers
        query_params = []
        if request_options
          query_params << request_options.expand unless request_options.expand == ''
        end

        method = 'post'
        url = Payrix.configuration.url
        endpoint = query_params.length < 1 ? resource_name : "#{@resource_name}?#{query_params.join('&')}"
        data = to_json
        process_http(method, url, endpoint, data, headers, timeout)
      end
    end
  end
end
