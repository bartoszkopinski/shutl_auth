module Shutl
  module  Auth
    class Shutl::Error       < ::StandardError; end
    class InvalidUrl         < Shutl::Error; end
    class InvalidCredentials < Shutl::Error; end

    def access_token!
      access_token_response!.access_token
    end

    def access_token_response!
      c = client

      Shutl::NetworkRetry.retry "Authentication Service Error" do
        begin
          c.access_token!
        rescue Rack::OAuth2::Client::Error
          raise_invalid_credentials
        end
      end
    end

    private

    def client
      check uri

      Rack::OAuth2::Client.new \
        identifier:     Shutl::Auth.client_id,
        secret:         Shutl::Auth.client_secret,
        token_endpoint: '/token',
        host:           uri.host,
        port:           uri.port,
        scheme:         uri.scheme
    end


    def uri
      URI Shutl::Auth.url
    rescue
      raise_invalid_uri
    end

    def check uri
      return uri if uri and uri.host and uri.scheme
      raise_invalid_uri

    rescue
      raise_invalid_uri
    end

    def raise_invalid_uri
      raise Shutl::Auth::InvalidUrl, "Please set value of Shutl::Auth.url"
    end

    def raise_invalid_credentials
      raise Shutl::Auth::InvalidCredentials, "Invalid credentials set, please see https://github.com/shutl/shutl_auth/blob/master/README.md"
    end
    extend self
  end
end
