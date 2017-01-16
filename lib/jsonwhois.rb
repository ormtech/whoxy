require "jsonwhois/version"
require "jsonwhois/configuration"

module Jsonwhois
  def self.configure(&block)
    @@configuration = Configuration.new
    yield(@@configuration)
  end

  def self.configuration
    @@configuration
  end

  class NoTokenError < Exception
  end

  class Client
    def initialize
      raise NoTokenError unless configuration && configuration.token
    end

    def lookup(uri)
      domain = parse_domain(uri)
      response = connection.get(whois_endpoint, domain: domain) do |request|
        request.headers[:authorization] = "Token token=#{configuration.token}"
      end

      response.body
    end

    def parse_domain(uri)
      parsed_uri = URI.parse(uri)
      parsed_uri = URI.parse("http://#{uri}") if parsed_uri.scheme.nil?

      # TODO handle mailto scheme
      parsed_uri.host.split(".").last(2).join(".")
    end

    private

    def connection
      configuration.connection
    end

    def configuration
      Jsonwhois.configuration
    end

    def whois_endpoint
      "/api/v1/whois"
    end

    def social_endpoint
      "/api/v1/social"
    end
  end
end
