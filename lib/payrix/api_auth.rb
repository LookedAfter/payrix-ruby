module Payrix
  module ApiAuth
    class << self
      def check_and_login
        if Payrix.configuration.bearer_token.nil?
          # load the token from external to Payrix.configuration at intial
          load_token
        end

        wait_while

        if Payrix.configuration.bearer_token.nil?
          authunticate
        else
          if token_expired?
            new_data = read_token
            new_data = new_data.blank? ? {} : JSON.parse(new_data)
            if Payrix.configuration.token_created_at == new_data['created_at']
              # saved auth details are not changed
              # therefore login
              authunticate
            else
              # saved auth details are changed
              # therefore load new auth details
              load_token
            end
          end
        end
        !token_expired?
      end

      private
        def save_token
          data = {
            'token' =>  Payrix.configuration.bearer_token,
            'expired_in' => Payrix.configuration.expired_in,
            'created_at' => Payrix.configuration.token_created_at,
            'auth_status' => Payrix.configuration.auth_status
          }
          File.write("tmp/payrix_api.txt", JSON.dump(data))
        end

        def read_token
          begin
            File.open('tmp/payrix_api.txt', 'r').read
          rescue
            # File note found, create file
            save_token
            File.open('tmp/payrix_api.txt', 'r').read
          end
        end

        def load_token
          data = read_token
          unless data.blank?
            data = JSON.parse(data)
            Payrix.configuration.bearer_token = data['token']
            Payrix.configuration.expired_in = (data['expired_in'].blank? ? 0 : data['expired_in']).to_i
            Payrix.configuration.token_created_at = data['created_at'].blank? ? 0 : data['created_at'].to_i
            Payrix.configuration.auth_status = data['auth_status']
          end
        end

        def wait_while(timeout = 2, retry_interval = 0.1)
          start = Time.now
          while (Payrix.configuration.auth_status == 'login')
            if (Time.now - start).to_i >= timeout
              load_token
              break
            end

            sleep(retry_interval)
            load_token
          end
        end

        def token_expired?
          offset_time = 60 #seconds
          token_validity_time = (Payrix.configuration.expired_in - offset_time).to_i
          (Time.now.to_i - Payrix.configuration.token_created_at) >= token_validity_time
        end

        def authunticate
          Payrix.configuration.bearer_token = nil
          Payrix.configuration.auth_status = 'login'
          auth = Payrix::Resource::Auth.new
          if auth.login(Payrix.configuration.api_username, Payrix.configuration.api_userkey)
            time_at = Time.now.to_i
            token = auth.response.body['access_token']
            if token
              Payrix.configuration.token_created_at = time_at
              Payrix.configuration.bearer_token = token
              Payrix.configuration.expired_in = auth.response.body['expires_in']
              Payrix.configuration.auth_status = 'success'
            else
              Payrix.configuration.auth_status = 'failed'
            end
            Payrix.configuration.auth_status = 'failed'
          end
          save_token
          Payrix::configuration.set_url(auth=false)
        end
    end
  end
end
