#can be included in for example a Rails controller to enable easily
#authenticating requests
module Shutl
  module Auth
    module AuthenticatedRequest

      #If a method called session is not defined in the included object
      #then it will be defined
      def self.included base
        unless base.instance_methods.include? :session
          raise egg
          base.class_eval do
            define_method :session do
              @session ||= {}
            end
          end
        end
      end

      def request_access_token
        return if session[:access_token]

        access_token_response = Shutl::Auth.access_token!
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
          access_token
          yield
        end
      end
    end
  end
end
