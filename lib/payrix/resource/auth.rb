module Payrix
  module Resource
    class Auth < Base
      def initialize(params={})
        super(params, ATTRS)
        @resource_name = 'login'
      end

      ATTRS = [:username, :password, :access_token, :expires_in, :token_type, :scope, :response]

      attr_accessor *ATTRS

      def self.login(api_username, api_userkey)
        auth = Payrix::Resource::Auth.new
        status = auth.post({Username: api_username, Password: api_userkey})
        if status
          token = auth.response.response['access_token']
          Payrix.configuration.bearer_token= token if token
        end
      end
    end
  end
end
