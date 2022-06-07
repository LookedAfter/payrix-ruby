require "payrix/version"
require "payrix/configuration"
require "payrix/exceptions"
require "payrix/http"
require "payrix/resource"

module Payrix
  class << self
    attr_writer :configuration
  end

  def self.configuration(auth: false, sandbox: false)
    @configuration ||= Configuration.new(auth: auth, sandbox: sandbox)
  end

  def self.configure
    yield(configuration)
  end
end
