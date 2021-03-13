# frozen_string_literal: true

require "b3e"

RSpec.describe "edge cases" do
  let(:result) {
    B3e.decode(B3e.encode(string))
  }

  context "sting is empty" do
    let(:string) {
      ""
    }

    it "encodes and decodes" do
      expect(result).to eq(string)
    end
  end

  context "string has leading zero" do
    let(:string) {
      "\x00s$\x02\xB3I".b
    }

    it "encodes and decodes" do
      expect(result).to eq(string)
    end
  end

  context "string has many leading zeros" do
    let(:string) {
      "\x00\x00\x00s$\x02\xB3I".b
    }

    it "encodes and decodes" do
      expect(result).to eq(string)
    end
  end

  context "string has leading zero and zeroes within" do
    let(:string) {
      "\x00s$\x02\x00\xB3I".b
    }

    it "encodes and decodes" do
      expect(result).to eq(string)
    end
  end
end
