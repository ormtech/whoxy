# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whoxy/version'

Gem::Specification.new do |spec|
  spec.name          = "whoxy"
  spec.version       = Whoxy::VERSION
  spec.authors       = ["Will Spurgin"]
  spec.email         = ["will.spurgin@orm-tech.com"]

  spec.summary       = %q{Basic Faraday driven ruby gem for interacting with the Whoxy API}
  spec.homepage      = "https://github.com/ormtech/whoxy"
  spec.license       = "MIT"

  spec.cert_chain    = ['certs/wspurgin.pem']
  spec.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.required_ruby_version = '~> 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday_middleware", "> 0.9.0", "< 0.11.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
