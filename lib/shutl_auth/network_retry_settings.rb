module Shutl

  module NetworkRetrySettings
    extend self

    def retry_connection message= "Notice: Network Exception", default=nil
      Retriable.retriable(retry_settings) { yield }
    rescue *network_exceptions => e
      Airbrake.notify(e, error_message: message)
      default
    end

    private

    def network_exceptions
      [
        Timeout::Error,
        Errno::ECONNREFUSED,
        EOFError,
        Net::HTTPBadResponse,
        Errno::ETIMEDOUT
      ]
    end

    def retry_settings options = {}
      interval = options[:sleep] || (test_mode ? 0 : 1)
      {on: network_exceptions, tries: 3, interval: interval}.merge options
    end

    #override based on environment
    def test_mode
      false
    end
  end

  class << self
    delegate :retry_connection, to: NetworkRetrySettings
  end
end
