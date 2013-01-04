#can be included in for example a Rails controller to enable easily
#authenticating requests
module Shutl
  module Auth
    module Session
      def session
        @session ||= {}
      end
    end

    module AuthenticatedRequest
      def self.included base
        unless base.instance_methods.include? :session
          base.class_eval do
            include Shutl::Auth::Session
          end
        end
      end

      def request_access_token
        return session[:access_token] if session[:access_token]

        Shutl::Auth.access_token!
      end

      def access_token
        session[:access_token] ||= request_access_token
      end

      def authenticated_request &blk
        begin
          yield
        rescue Shutl::UnauthorizedAccess => e
          session[:access_token] = nil
          access_token
          yield
        end
      end
    end
  end
end
