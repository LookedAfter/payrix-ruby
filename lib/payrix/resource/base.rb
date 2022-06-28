module Payrix
  module Resource
    class Base
      attr_reader :resource_name

      def initialize(params, attrs)
        @attrs = attrs
        @request_options = Payrix::Http::RequestParams.new
        set(params)
      end

      def request_options
        @request_options
      end

      def request_options=(params = {})
        @request_options.sort = params['sort'] unless params['sort'].nil?
        @request_options.expand = params['expand'] unless params['expand'].nil?
        @request_options.totals = params['totals'] unless params['totals'].nil?
        @request_options.page = params['page'] unless params['page'].nil?
      end

      def set(params)
        if params.is_a?(Hash) && !params.empty?
          params.each do |k, v|
            if @attrs.include? k
              public_send("#{k}=", v) if respond_to? "#{k}="
            else
              self.class.send(:attr_accessor, k)
              self.instance_variable_set("@#{k}", v);
            end
          end
        end
      end

      def to_json(nested = false)
        excludes = ['request_options', 'parent_resource', 'resource_name', 'response', 'attrs']

        instance_variables.inject({}) do |hash, var|
          key = var.to_s.delete('@')
          val = instance_variable_get(var)

          if !excludes.include? key
            if val.is_a? Base
              hash[key] = val.to_json(true) if nested
            else
              hash[key] = val
            end
          end

          hash
        end
      end

      def status
        @response.nil? ? false : @response.status
      end

      def has_errors?
        @response.nil? ? false : @response.has_errors?
      end

      def response
        @response.nil? ? [] : @response.response
      end

      def details
        @response.nil? ? [] : @response.details
      end

      def totals
        @response.nil? ? [] : @response.totals
      end

      def has_more?
        @response.nil? ? true : @response.has_more?
      end

    protected
      def build_headers()
        config = Payrix.configuration

        if !config.url
          raise Payrix::InvalidRequestError.new('Invalid URL')
        end

        headers = {}

        if config.bearer_token
          headers['Authorization'] = "Bearer #{config.bearer_token}"
        end
        headers['Content-Type'] = "application/json"
        headers
      end

      def build_query_params(values = {})
        values
          .delete_if { |k, v| v.nil? || v.empty? }
          .map { |k, v| v.is_a?(Array) ? v.map {|x| "#{k}=#{x}"}.joins('&') : "#{k}=#{v}" }
          .join('&')
      end

      def process_http(method, url, endpoint, data, headers, timeout=nil)
        @response = nil # clear response for new request
        begin
          response = Payrix::Http::Request.instance.send_http(method, url, endpoint, data, headers, timeout)
          body = response.body
          status = response.status
          json = body.present? ? JSON.parse(body) : ''
          @response = Payrix::Http::Response.new(json, status, self.class)
        rescue JSON::ParserError
          raise Payrix::InvalidResponseError.new('Invalid response object')
        rescue Payrix::Error => e
          body = e.response[:body]
          json = (body || '').length >=2 ? JSON.parse(e.response[:body]) : {}
          @response = Payrix::Http::ErrorResponse.new(json, e.response[:status], self.class, e.class)
        end
        validate_response
      end

      def validate_response
        if @response.class == Payrix::Http::ErrorResponse
          false
        else
          true
        end
      end
    end
  end
end
