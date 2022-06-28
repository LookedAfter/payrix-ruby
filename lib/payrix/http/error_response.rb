module Payrix
  module Http
    class ErrorResponse
      attr_reader :status, :body

      def initialize(response = {}, status = '', cls, err_cls)
        @body = response
        @status = status
        @cls = cls
        @err_cls = err_cls
      end

      def code
        @body['errorCode']
      end

      def message
        @body['errorMessage']
      end

      def detail
        @body['errorDetail']
      end
    end
  end
end
