# frozen_string_literal: true

require "base64"
require "benchmark/ips"
require "securerandom"

require "b3e"

string = SecureRandom.random_bytes(512)

encoded62 = B3e.encode(string)
encoded64 = Base64.urlsafe_encode64(string, padding: false)

Benchmark.ips do |ips|
  ips.config(time: 5, warmup: 1)

  ips.report("b3e") do
    B3e.decode(encoded62)
  end

  ips.report("base64") do
    Base64.urlsafe_decode64(encoded64)
  end

  ips.compare!
end
