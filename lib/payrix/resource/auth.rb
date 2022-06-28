module Payrix
  module Resource
    class Auth < Base
      include Payrix::HttpOperation::Post

      def initialize(params={})
        super(params, ATTRS)
        Payrix::configuration.set_url(auth=true)
        @resource_name = 'login'
      end

      ATTRS = [:username, :password, :access_token, :expires_in, :token_type, :scope, :response]

      attr_accessor *ATTRS

      def self.login(api_username, api_userkey)
        # Authorize and get token from Payrix Authentication
        auth = Payrix::Resource::Auth.new
        status = auth.post({Username: api_username, Password: api_userkey})
        if status
          time_at = Time.now.to_i
          token = auth.response.body['access_token']
          if token
            Payrix.configuration.token_created_at = time_at
            Payrix.configuration.bearer_token = token
            Payrix.configuration.expired_in = auth.response.body['expires_in']
          end
        end
        Payrix::configuration.set_url(auth=false)
        status
      end

      def login(api_username, api_userkey)
        post({Username: api_username, Password: api_userkey})
      end

    end
  end
end
