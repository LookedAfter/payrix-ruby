module Payrix
  module HttpOperation
    module Put
      def put(params = {})
        set(params)

        headers = build_headers
        method = 'put'
        url = Payrix.configuration.url
        data = to_json

        process_http(method, url, @resource_name, data, headers)
      end
    end
  end
end
