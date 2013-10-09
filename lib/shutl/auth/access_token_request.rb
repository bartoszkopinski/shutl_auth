module Shutl
  module  Auth
    class AccessTokenRequest

      def initialize(opts)
        self.client_id = opts.fetch :client_id
        self.client_secret = opts.fetch :client_secret
        self.url = opts.fetch :url
      end

      def access_token
        access_token_response.access_token
      end

      def access_token_response
        c = client

        Shutl::NetworkRetry.retry "Authentication Service Error" do
          handling_exceptions do
            Shutl::Auth.logger.debug "executing Rack::OAuth2::Client request"
            c.access_token!
          end
       end
      end

      private

      attr_accessor :client_id, :client_secret, :url


      def handling_exceptions
        yield
      rescue Rack::OAuth2::Client::Error => e
        Shutl::Auth.logger.error "Rack::OAuth2::Client::Error: #{e.message}"
        case e.message
        when /The client identifier provided is invalid, the client failed to authenticate, the client did not include its credentials, provided multiple client credentials, or used unsupported credentials type\./
          raise_invalid_credentials
        else
          raise_internal_server_error e
        end
      end

      def client
        check uri

        Rack::OAuth2::Client.new \
          identifier:     client_id,
          secret:         client_secret,
          token_endpoint: '/token',
          host:           uri.host,
          port:           uri.port,
          scheme:         uri.scheme
      end


      def uri
        URI url
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
    end
  end
end
