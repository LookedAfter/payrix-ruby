module Payrix
  module HttpOperation
    module Get
      def get(params = {})
        set(params)

        headers = build_headers
        query_params = build_query_params(to_json)

        method = 'get'
        url = Payrix.configuration.url
        endpoint = query_params.empty? ? @resource_name : "#{@resource_name}?#{query_params}"
        data = {}

        process_http(method, url, endpoint, data, headers)
      end
    end
  end
end
