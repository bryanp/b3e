# frozen_string_literal: true

require "securerandom"
require "b3e"

RSpec.describe "using b3e with random alphanumerics" do
  1_000.times do
    string = SecureRandom.alphanumeric((rand * 100).to_i)

    it "encodes and decodes: #{string}" do
      encoded = B3e.encode(string)
      expect(encoded).to match(/^[a-zA-Z0-9]*$/)
      expect(B3e.decode(encoded)).to eq(string)
    end
  end
end

RSpec.describe "using b3e with random bytes" do
  1_000.times do
    string = SecureRandom.random_bytes((rand * 100).to_i)

    it "encodes and decodes: #{string}" do
      expect(B3e.decode(B3e.encode(string))).to eq(string)
    end
  end
end
