require 'singleton'
require 'json'

require 'faraday'
require 'faraday/net_http'
require "payrix/raise_error_middleware"

module Payrix
  module Http
    class Request
      include Singleton

      def initialize
      end

      def send_http(method, base_url, endpoint, data = {}, headers = {}, timeout = nil)
        timeout ||= 30 #seconds
        conn = Faraday.new(url: base_url) do |conn|
          conn.headers = headers
          conn.options.timeout = timeout
          conn.options.open_timeout = timeout
          conn.request :json
          log_level = Payrix::configuration.log_level
          conn.response :logger, nil, { headers: true, bodies: true, log_level: log_level} do | logger | #TODO: config option
            logger.filter(/(access_token)([^&]+)/, '\1[REMOVED]')
            logger.filter(/(Username)([^&]+)/, '\1[REMOVED]')
            logger.filter(/(Password)([^&]+)/, '\1[REMOVED]')
            logger.filter(/(Bearer)([^&]+)/, '\1[REMOVED]')
            logger.filter(/(CardToken)([^&]+)/, '\1[REMOVED]')
          end
          conn.response :raise_error_middleware

          conn.adapter :net_http
        end

        conn.send(method.downcase.to_sym, endpoint, data)
      end
    end
  end
end
