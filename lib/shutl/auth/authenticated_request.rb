#can be included in for example a Rails controller to enable easily
#authenticating requests
module Shutl
  module Auth
    module AuthenticatedRequest
      def self.included base
      end

      def access_token
        authenticator.access_token
      end

      def authenticated_request &blk
        authenticator.authenticated_request &blk
      end

      def request_access_token
        authenticator.request_access_token
      end

      protected

      def authenticator
        @authenticator ||= Authenticator.new
      end
    end

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

    def self.cache
      @cache ||= build_cache
    end

    private

    def self.build_cache
      if Kernel.const_defined?(:Rails)
        ::Rails.cache
      else
        Cache.new
      end
    end
  end
end
