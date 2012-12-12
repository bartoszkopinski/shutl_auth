require "shutl_auth/version"
require "rack/oauth2"
require "retriable/no_kernel"
require "shutl_auth/network_retry_settings"
require "shutl_auth/access_token_request"
require "shutl_auth/authentication"

module Shutl
  module Auth
    extend self

    attr_accessor :client_id, :client_secret, :url

    def config
      yield self
    end
  end
end
