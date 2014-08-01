require "rack/oauth2"
require "retriable/no_kernel"
require "shutl/network_retry"

require "shutl/auth/version"
require "shutl/auth/access_token_request"
require "shutl/auth/authenticated_request"
require "shutl/auth/authenticator"

require 'logger'

module Shutl
  class UnauthorizedAccess < ::StandardError
    attr_reader :status

    def initialize(message = nil, status = nil)
      super(message)
      @status = status
    end
  end

  class Error              < ::StandardError;  end

  module Auth
    class InvalidUrl          < Shutl::Error; end
    class InvalidCredentials  < Shutl::Error; end
    class InternalServerError < Shutl::Error; end

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

module Faraday
  class TimeoutError ; end
  class ConnectionFailed ; end
  class ParsingError ; end
  class SSLError ; end
end