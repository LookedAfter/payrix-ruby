module Payrix
  class Configuration
    attr_reader :url
    attr_accessor :bearer_token, :exception_enabled

    def initialize(auth: false, sandbox: true)
      @url = auth ? get_auth_url(sandbox) : get_url(sandbox)
      @bearer_token = nil
    end

    def exception_enabled=(v)
      @exception_enabled = !!v
    end

    private
      def get_auth_url(sandbox)
        sandbox ? 'https://sandbox.auth.paymentsapi.io' : 'https://auth.paymentsapi.io'
      end

      def get_url(sandbox)
        sandbox ? 'https://sandbox.rest.paymentsapi.io' : ' https://rest.paymentsapi.io'
      end
    # end private
  end
end