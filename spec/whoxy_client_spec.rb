require "spec_helper"

describe Whoxy::Client do
  describe ".new" do
    it "raises a MissingAPIKeyError if no configuration was set" do
      expect { Whoxy::Client.new }.to raise_error(Whoxy::MissingAPIKeyError)
    end

    it "raises a MissingAPIKeyError if no key was set in the configuration" do
      Whoxy.configure { |c| }
      expect { Whoxy::Client.new }.to raise_error(Whoxy::MissingAPIKeyError)
    end
  end

  describe "#parse_domain" do
    before do
      Whoxy.configure do |config|
        config.key = "astubbedkey"
      end
    end

    subject(:client) { described_class.new }

    it "correctly parses URIs without schemes" do
      google = "google.com"
      expect(client.parse_domain(google)).to eq google
      expect(client.parse_domain("foobar.google.com")).to eq google
    end

    it "correctly parses URIs with schemes" do
      google = "google.com"
      expect(client.parse_domain("http://#{google}")).to eq google
      expect(client.parse_domain("http://foobar.google.com")).to eq google
    end

    it "parses mailto URIs correctly" do
      foo = "foo.com"
      expect(client.parse_domain("mailto:bar@foo.com")).to eq foo
    end

    it "correctly parses combinations of TLDs with international TLDs" do
      foo = "foo.com.uk"
      bar = "bar.uk.com"
      baz = "baz.co.gm"

      expect(client.parse_domain(foo)).to eq foo
      expect(client.parse_domain(bar)).to eq bar
      expect(client.parse_domain(baz)).to eq baz
    end

    it "correctly parses out subdomains" do
      foo = "foo.com"
      bar = "bar.co.uk"

      expect(client.parse_domain("sub.#{foo}")).to eq foo
      expect(client.parse_domain("sub.#{bar}")).to eq bar
    end
  end
end
