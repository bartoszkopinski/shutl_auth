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
        Shutl::Auth.logger.debug "request_access_token: in session? #{!!session[:access_token]}"
        return read_token if read_token

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
        Shutl::Auth.logger.debug "access token #{session[:access_token]}"
        session[:access_token]
      end

      def set_token(token)
        Shutl::Auth.logger.debug "setting access token #{token}"
        session[:access_token] = token
      end
    end
  end
end
