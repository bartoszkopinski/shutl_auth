module Shutl
  module  Auth
    class Shutl::Error       < ::StandardError; end
    class InvalidUrl         < Shutl::Error; end
    class InvalidCredentials < Shutl::Error; end

    def access_token!
      access_token_response!.access_token
    end

    def access_token_response!
      Shutl::NetworkRetry.retry "Authentication Service Error" do
        client.access_token!
      end
    end

    private

    def client
      Rack::OAuth2::Client.new \
        identifier:     Shutl::Auth.client_id,
        secret:         Shutl::Auth.client_secret,
        token_endpoint: '/token',
        host:           uri.host,
        port:           uri.port,
        scheme:         uri.scheme

    rescue Rack::OAuth2::Client::Error => e
      debugger
      puts e.message
      raise_invalid_credentials

    rescue Exception => e
      debugger
      puts e.message

    end

    def uri
      check URI Shutl::Auth.url

    rescue URI::InvalidURIError
      raise_invalid_uri
    end

    def check uri
      return uri if uri and uri.host and uri.scheme

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
