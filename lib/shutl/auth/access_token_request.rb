module Shutl
  module  Auth
    def access_token!
      access_token_response!.token
    end

    def access_token_response!
      Shutl::NetworkRetry.retry "Authentication Service Error" do
        client.access_token!
      end
    end

    private

    def client
      #TODO: handle the various exceptions that can be thrown by the OAuth2
      #gem and turn into Shutl specific exceptions
      Rack::OAuth2::Client.new(
        identifier:     Shutl::Auth.client_id,
        secret:         Shutl::Auth.client_secret,
        token_endpoint: '/token',
        host:           uri.host,
        port:           uri.port,
        scheme:         uri.scheme
      )
    end

    def uri
      URI Shutl::Auth.url
    end

    extend self
  end
end
