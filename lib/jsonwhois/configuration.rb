require 'jsonwhois/faraday_middleware'

module Jsonwhois
  class Configuration
    attr_accessor :token, :debug

    def connection(&block)
      @connection ||= if block_given?
                        Faraday.new(jsonwhois_host, &block)
                      else
                        default_connection
                      end
    end

    def default_connection
      @connection = Faraday.new(jsonwhois_host) do |conn|
        conn.request :url_encoded

        conn.request :retry, max: 10, interval: 0.05,
          interval_randomness: 0.5, backoff_factor: 2,
          exceptions: [Errno::ETIMEDOUT, 'Timeout::Error',
                      ::Faraday::Error::TimeoutError,
                      ::Faraday::ConnectionFailed]

        conn.response :jsonwhois, content_type: /\bjson$/
        conn.response :logger if debug

        conn.adapter Faraday.default_adapter
      end
    end

    private

    def jsonwhois_host
      { url: "https://jsonwhois.com" }
    end
  end
end

