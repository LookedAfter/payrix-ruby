# frozen_string_literal: true

require "payrix/version"
require "payrix/configuration"
require "payrix/errors"
require "payrix/code_description"

# hhtp_operation
require "payrix/http_operation/get"
require "payrix/http_operation/post"
require "payrix/http_operation/put"
require "payrix/http_operation/delete"

# http
require "payrix/http/request_params"
require "payrix/http/request"
require "payrix/http/response"
require "payrix/http/error_response"

# Resources
require "payrix/resource/base"
require "payrix/resource/auth"
require 'payrix/api_auth'
require "payrix/resource/businesses"
require "payrix/resource/payers"
require "payrix/resource/transactions"
require "payrix/resource/bpay"

module Payrix
  class << self
    # attr_writer :configuration

    def configuration(sandbox: true)
      @configuration ||= Configuration.new(sandbox)
    end

    def configure(sandbox: false)
      yield(configuration(sandbox: sandbox))
    end
  end
end
