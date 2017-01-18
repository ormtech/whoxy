require "whoxy/version"
require "whoxy/configuration"

module Whoxy
  def self.configure(&block)
    @@configuration = Configuration.new
    yield(@@configuration)
  end

  def self.configuration
    @@configuration ||= nil
  end

  class MissingAPIKeyError < Exception
  end

  class Client
    def initialize
      raise MissingAPIKeyError unless configuration && configuration.key
    end

    def lookup(uri, &block)
      domain = parse_domain(uri)
      response = connection.get(whois_endpoint, whois: domain, key: configuration.key) do |request|
        yield request if block_given?
      end

      response.body
    end

    def parse_domain(uri)
      parsed_uri = URI.parse(uri)
      parsed_uri = URI.parse("http://#{uri}") if parsed_uri.scheme.nil?

      host = parsed_uri.host

      # Handle mailto scheme
      if parsed_uri.scheme == "mailto"
        _, address_host = uri.split("@")
        host = address_host
      end

      fail ArgumentError.new("Could not parse #{uri} for a domain") if host.nil?

      # Check for subdomains or combined TLD with ccTLD
      num_separators = host.count "."
      domain = if num_separators > 1
        # if this is a combined TLD, one or both of the last two have to be an
        # international ccTLD (like uk or gm) which are only 2 characters long.
        possible_tlds = host.split(".").last(2)
        cctld_detected = possible_tlds.map { |tld| tld.size == 2 }.reduce(:|)
        num_to_select = if cctld_detected
                          3
                        else # The were no ccTLDs
                          2
                        end
        host.split(".").last(num_to_select).join(".")
      else # there's no subdomain or combined TLD
        host
      end

      domain
    end

    private

    def connection
      configuration.connection
    end

    def configuration
      Whoxy.configuration
    end

    def whois_endpoint
      "/"
    end
  end
end
