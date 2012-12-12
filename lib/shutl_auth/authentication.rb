#can be included in for example a Rails controller to enable easily
#authenticating requests
#Depends on session being defined in the included object, and this being hash-like
module Shutl
  module Auth
    module AuthenticatedRequest
      def request_access_token
        return if session[:access_token]

        access_token_response = Shutl::Auth::AccessTokenRequest.new.access_token!
        access_token_response.access_token
      end

      def access_token
        session[:access_token] ||= request_access_token
      end

      def authenticated_request &blk
        begin
          yield
        rescue Shutl::UnauthorizedAccess => e
          session[:access_token] = nil
          request_access_token
          yield
        end
      end
    end
  end
end
