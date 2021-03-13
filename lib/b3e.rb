# frozen_string_literal: true

module B3e
  # [public] Raised when the value cannot be encoded or decoded.
  #
  class Invalid < StandardError
  end

  # [public] Encode a string as Base62.
  #
  def self.encode(value)
    if value.size > 0
      c_encode(value)
    else
      ""
    end
  end

  # [public] Decode a Base62 string back to its original value.
  #
  def self.decode(value)
    if value.size > 0
      c_decode(value)
    else
      ""
    end
  end

  require_relative "b3e/version"
end

require_relative "b3e_ext"
