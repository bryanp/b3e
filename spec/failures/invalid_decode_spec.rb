# frozen_string_literal: true

require "b3e"

RSpec.describe "decoding an invalid string" do
  it "raises" do
    expect {
      B3e.decode("abc$")
    }.to raise_error(B3e::Invalid, "encountered a character that is not in the base62 alphabet")
  end
end
