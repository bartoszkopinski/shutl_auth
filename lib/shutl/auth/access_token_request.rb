module Shutl
  module  Auth
    class Shutl::Error        < ::StandardError; end
    class InvalidUrl          < Shutl::Error; end
    class InvalidCredentials  < Shutl::Error; end
    class InternalServerError < Shutl::Error; end

    def access_token!
      access_token_response!.access_token
    end

    def access_token_response!
      c = client

      Shutl::NetworkRetry.retry "Authentication Service Error" do
        begin
          c.access_token!
        rescue Rack::OAuth2::Client::Error => e
          case e.message
          when /The client identifier provided is invalid, the client failed to authenticate, the client did not include its credentials, provided multiple client credentials, or used unsupported credentials type\./
            raise_invalid_credentials
          else
            raise_internal_server_error e
          end
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

    def raise_internal_server_error e
      Shutl.notify e
      raise Shutl::Auth::InternalServerError
    end

    extend self
  end
end
