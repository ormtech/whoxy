require 'faraday'

module Whoxy
  module FaradayMiddleware
    autoload :Response, 'whoxy/faraday_middleware/response'
  end

  if Faraday::Middleware.respond_to? :register_middleware
    Faraday::Response.register_middleware whoxy: -> { Whoxy::FaradayMiddleware::Response }
  end
end

