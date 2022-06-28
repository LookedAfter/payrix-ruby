module Payrix
  class Configuration
    attr_reader :sandbox
    attr_accessor :url, :api_username, :api_userkey, :log_level, :bearer_token, :auth_status,
                  :exception_enabled, :expired_in, :token_created_at

    def initialize(sandbox)
      @sandbox = sandbox
      @bearer_token = nil
      @log_level = :info
      @api_username = nil
      @api_userkey = nil
      set_url
    end

    def exception_enabled=(v)
      @exception_enabled = !!v
    end

    def set_url(auth=false)
      @url = auth ? get_auth_url : get_rest_url
    end

    private
      def get_auth_url
        @sandbox ? 'https://sandbox.auth.paymentsapi.io' : 'https://auth.paymentsapi.io'
      end

      def get_rest_url
        @sandbox ? 'https://sandbox.rest.paymentsapi.io' : ' https://rest.paymentsapi.io'
      end
    # end private
  end
end