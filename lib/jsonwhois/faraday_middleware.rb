require 'faraday'

module Jsonwhois
  module FaradayMiddleware
    autoload :Response, 'jsonwhois/faraday_middleware/response'
  end

  if Faraday::Middleware.respond_to? :register_middleware
    Faraday::Response.register_middleware jsonwhois: -> { Jsonwhois::FaradayMiddleware::Response }
  end
end

