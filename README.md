# Jsonwhois

Interact with the [JsonWhois](https://jsonwhois.com/) API for retrieving WHOIS
data on domains.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonwhois'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonwhois

## Usage

Simply require the service, configure your key, then start looking up domains.

```ruby
require 'jsonwhois'

Jsonwhois.configure do |config|
  config.token = ENV['JSONWHOIS_TOKEN']
  # specify your own faraday connection (except for host)
  # config.connection do |conn|
  # ...
  # end
end

whois = Jsonwhois::Client.new
whois.lookup("google.com")
#=> Hash
```

### URI Handling

Rather than force you to remember to take off sub-domains or URI schemes, the
`lookup` command can handle that for you.

```ruby
# ✓ returns JsonWhois API results for 'ofdomain.com'
whois.lookup("subdomain.ofdomain.com")

# ✓ returns JsonWhois API results for 'google.com'
whois.lookup("http://google.com")

# ✓ returns JsonWhois API results for 'bar.com'
whois.lookup("mailto:foo@bar.com")

# ✗ produces ArgumentError because it was neither a URI nor a parsable domain
whois.lookup("foo@bar.com')
#=> raises ArgumentError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jsonwhois.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

