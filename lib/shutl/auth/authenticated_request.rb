#can be included in for example a Rails controller to enable easily
#authenticating requests
module Shutl
  module Auth
    class Cache
      def initialize
        @cache = {}
      end

      def read(key)
        @cache[key]
      end

      def write(key, value)
        @cache[key] = value
      end
    end

    module AuthenticatedRequest
      def self.included base
        
      end

      def request_access_token
        Shutl::Auth.logger.debug "request_access_token: cached? #{!!read_token}"

        Shutl::Auth.logger.debug "requesting new access token"
        Shutl::Auth.access_token!
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

      def read_token
        cache.read(:access_token)
      end

      def set_token(token)
        cache.write(:access_token, token)
      end

      def cache
        @cache ||= build_cache
      end

      private

      def build_cache
        if Kernel.const_defined?(:Rails)
          Rails.cache
        else
          Cache.new
        end
      end
    end
  end
end
