# frozen_string_literal: true

require File.expand_path("../lib/b3e/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "b3e"
  spec.version = B3e::VERSION
  spec.summary = "Fast Base62 for Ruby."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@metabahn.com"
  spec.homepage = "https://github.com/metabahn/b3e/"

  spec.required_ruby_version = ">= 2.5.0"

  spec.license = "MPL-2.0"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*"]
  spec.require_path = "lib"

  spec.extensions = %w[ext/b3e/extconf.rb]
end
