
module Shutl
  module Auth
    class Authenticator

      def initialize(options = {})
        self.cache_key = options.fetch(:cache_key) { :access_token }
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

        Shutl::Auth.access_token!
      end

      private

      attr_accessor :cache_key

      def read_token
        Shutl::Auth.cache.read(cache_key)
      end

      def set_token(token)
        Shutl::Auth.cache.write(cache_key, token)
      end
    end
  end
end