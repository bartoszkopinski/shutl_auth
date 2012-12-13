require "rack/oauth2"
require "retriable/no_kernel"
require "shutl/network_retry_settings"

require "shutl/auth/version"
require "shutl/auth/access_token_request"
require "shutl/auth/authenticated_request"

module Shutl
  module Auth
    extend self

    attr_accessor :client_id, :client_secret, :url

    def config
      yield self
    end
  end
end
