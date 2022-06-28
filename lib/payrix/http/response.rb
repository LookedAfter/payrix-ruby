module Payrix
  module Http
    class Response
      attr_reader :status, :body

      def initialize(response = {}, status = '', cls)
        @body = response
        @status = status
        @cls = cls
      end

      def totals
        (@response['response'] && @response['response']['details'] && @response['response']['details']['totals']) || {}
      end

      def has_more?
        page = @response['response'] && @response['response']['details'] && @response['response']['details']['page']

        !page.nil? &&
        !page['current'].nil? &&
        !page['last'].nil? &&
        page['current'] < page['last']
      end

    end
  end
end
