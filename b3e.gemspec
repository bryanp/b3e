# frozen_string_literal: true

require File.expand_path("../lib/b3e/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "b3e"
  spec.version = B3e::VERSION
  spec.summary = "Fast Base62 for Ruby."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@bryanp.org"
  spec.homepage = "https://github.com/bryanp/b3e/"

  spec.required_ruby_version = ">= 2.6.7"

  spec.license = "MPL-2.0"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*", "ext/**/*"]
  spec.require_path = "lib"

  spec.extensions = %w[ext/b3e/extconf.rb]
end
