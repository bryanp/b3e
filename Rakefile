# frozen_string_literal: true

require "fileutils"
require "rake/extensiontask"

Rake::ExtensionTask.new "b3e_ext" do |ext|
  ext.ext_dir = "ext/b3e"
end

task test: :compile do
  unless system "bundle exec rspec"
    exit $?.exitstatus
  end
end

task :clean do
  [
    "./lib/b3e_ext.bundle"
  ].each do |file|
    next unless File.exist?(file)

    FileUtils.rm(file)
  end
end

task build: %i[test clean] do
  system "gem build b3e.gemspec"
end
