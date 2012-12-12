require "shutl_auth/version"
require "rack/oauth2"
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
