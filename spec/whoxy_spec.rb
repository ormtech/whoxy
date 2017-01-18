require "spec_helper"

describe Whoxy do
  it "has a version number" do
    expect(Whoxy::VERSION).not_to be nil
  end

  describe ".configure" do
    it "yeilds a Whoxy::Configuration" do
      specify { expect { |b| Whoxy.configure(&b) } }.to yield_with_args(Whoxy::Configuration)
    end

    it "overwrites the previous configuration when called a second time" do
      Whoxy.configure { |c| c.key = "foo" }
      config = Whoxy.configuration
      Whoxy.configure { |c| c.key = "bar" }
      expect(Whoxy.configuration).not_to be_nil
      expect(Whoxy.configuration).not_to eq config
      expect(Whoxy.configuration.key).to eq "bar"
    end
  end

  describe ".configuration" do
    it "returns nil if `.configure` was not called first" do
      expect(Whoxy.configuration).to be_nil
    end

    it "returns the configuration that was specified with configure" do
      Whoxy.configure { |config| config.key = "my_key" }
      config = Whoxy.configuration
      expect(config).to be_a(Whoxy::Configuration)
      expect(config.key).to eq "my_key"
    end
  end
end
