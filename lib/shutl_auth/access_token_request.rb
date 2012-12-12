module Shutl
  module  Auth
    class AccessTokenRequest
      def initialize
        #TODO: handle the various exceptions that can be thrown by the OAuth2 gem
        #and turn into Shutl specific exceptions
        @client = Rack::OAuth2::Client.new(
          identifier: Shutl::Auth.client_id,
          secret:     Shutl::Auth.client_secret,
          host:       uri.host,
          port:       uri.port,
          scheme:     uri.scheme
        )
      end

      def access_token!
        Shutl.retry_connection "Authentication Service Error" do
          @client.access_token!
        end
      end

      private

      def uri
        #TODO: standardize naming/config of shutl_rails/shutl_resource/shutl_auth
        @uri ||= URI Shutl.authentication_service[:url]
      end
    end
  end
end
