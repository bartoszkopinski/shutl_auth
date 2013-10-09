require "rack/oauth2"
require "retriable/no_kernel"
require "shutl/network_retry"

require "shutl/auth/version"
require "shutl/auth/access_token_request"
require "shutl/auth/authenticated_request"
require "shutl/auth/authenticator"

require 'logger'

module Shutl
  class UnauthorizedAccess < StandardError ; end

  module Auth
    extend self

    attr_accessor :client_id, :client_secret, :url

    def config
      yield self
    end

    def logger
      return ::Rails.logger if Kernel.const_defined?(:Rails)
      return ::Shutl.logger if Shutl.respond_to? :logger
      Logger.new('/dev/null')
    end
  end
end
