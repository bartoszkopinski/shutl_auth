
module Shutl
  module Auth
    class Authenticator

      def initialize(options = {})
        Shutl::Auth.logger.debug "building a new authenticator"
        self.cache_key      = options.fetch(:cache_key) { :access_token }
        self.client_id      = options.fetch(:client_id)
        self.client_secret  = options.fetch(:client_secret)
        self.url            = options.fetch(:url)
      end

      def access_token
        return read_token if read_token
        set_token request_access_token
      end

      def authenticated_request &blk
        begin
          yield
        rescue Shutl::UnauthorizedAccess => e
          Shutl::Auth.logger.debug "Shutl::UnauthorizedAccess - resetting access token"
          set_token nil
          access_token
          yield
        end
      end

      def request_access_token
        return read_token if read_token
        Shutl::Auth.logger.debug "request_access_token: cached? #{!!read_token}"

        AccessTokenRequest.new(opts).access_token
      end

      private

      attr_accessor :cache_key, :client_id, :client_secret, :url

      def read_token
        Shutl::Auth.cache.read(cache_key)
      end

      def set_token(token)
        Shutl::Auth.cache.write(cache_key, token)
      end

      def opts
        {
          client_id:     client_id,
          client_secret: client_secret,
          url:           url
        }
      end
    end
  end
end