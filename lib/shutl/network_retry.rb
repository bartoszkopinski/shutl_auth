module Shutl
  module NetworkRetry
    def retry message= "Notice: Network Exception", default=nil
      Retriable.retriable(retry_settings) { yield }
    rescue *network_exceptions => e
      notifier_klass.notify(e, error_message: message)
      default
    end

    attr_writer :notifier_klass

    def notifier_klass
      @notifier_klass ||= Airbrake
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

    class << self
      delegate :retry_connection, to: NetworkRetry
    end

    extend self
  end

end
