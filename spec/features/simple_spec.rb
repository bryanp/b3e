# frozen_string_literal: true

require "b3e"

RSpec.describe "simple encode/decode" do
  it "encodes" do
    expect(B3e.encode("abc")).to eq("jJWY")
  end

  it "decodes" do
    expect(B3e.decode("jJWY")).to eq("abc")
  end

  it "encodes single character strings" do
    expect(B3e.encode("0")).to eq("wA")
  end

  it "encodes a longer string" do
    string = "mGJnOID9uf7lOyrd4O7Z0QStsr0ySBRi55b6wXtaY4MFG8KgL4PFWtC7SJSEmpfHpOPd80hMwnOZxj363bkhsU3CMdB1D23T259HMUeJ2V9qiNq8rZpvxEQm1di1jYnq"
    result = "x5WWqFTakFTbRVEesDOtkDn4cKt4yxKZUqsqaCpcqRGqmRGiiRIyaaoZqaO0WTsZsZG1wTrnc7umQDGcIDqngDJzgrtimSppuZI6uyIoohpzWCnjMqJayKM6w6ObErmaSTKhmKPYkbO6mKKY06mnohM5y7J2uxs6yhokekbKdUb"

    expect(B3e.encode(string)).to eq(result)
  end

  it "decodes a longer string" do
    string = "mGJnOID9uf7lOyrd4O7Z0QStsr0ySBRi55b6wXtaY4MFG8KgL4PFWtC7SJSEmpfHpOPd80hMwnOZxj363bkhsU3CMdB1D23T259HMUeJ2V9qiNq8rZpvxEQm1di1jYnq"
    result = "x5WWqFTakFTbRVEesDOtkDn4cKt4yxKZUqsqaCpcqRGqmRGiiRIyaaoZqaO0WTsZsZG1wTrnc7umQDGcIDqngDJzgrtimSppuZI6uyIoohpzWCnjMqJayKM6w6ObErmaSTKhmKPYkbO6mKKY06mnohM5y7J2uxs6yhokekbKdUb"

    expect(B3e.decode(result)).to eq(string)
  end

  it "encodes and decodes a longer string" do
    string = "NQvsbx5zmwSyjgIOab1DJwZbKWU4DfRNyWzipV5XuSyNkTrK4tYAo5RKc5XLFeyduCds8lLMzU8I2NKIEzaO0PcxwapI"

    expect(B3e.decode(B3e.encode(string))).to eq(string)
  end
end
