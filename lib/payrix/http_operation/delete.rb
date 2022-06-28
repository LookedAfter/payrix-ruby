module Payrix
  module HttpOperation
    module Delete
      def delete(params = {})
        set(params)

        headers = build_headers
        method = 'delete'
        url = Payrix.configuration.url
        data = {}

        process_http(method, url, @resource_name, data, headers)
      end
    end
  end
end
