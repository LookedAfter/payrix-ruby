module Payrix
  module Resource
    class Businesses < Base
      include Payrix::HttpOperation::Get

      def initialize(params={})
        super({}, ATTRS)
        @resource_name = 'businesses'
      end

      ATTRS = [:business_id, :scope, :response]

      attr_accessor *ATTRS

      def status(business_id)
        Payrix::ApiAuth.check_and_login
        @resource_name = "businesses/#{business_id}/status"
        get()
      end
    end
  end
end
