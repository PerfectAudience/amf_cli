# frozen_string_literal: true

require_relative "lib/amf/version"

Gem::Specification.new do |spec|
  spec.name          = "AMF"
  spec.version       = AMF::VERSION
  spec.authors       = ["Donovan Young"]
  spec.email         = ["donovan.young@perfectaudience.com"]

  spec.summary       = "simple CLI utility to produce AMF reporting"
  spec.description   = "Produces various AMF reports as specified by input options"
  spec.homepage      = "http://example.org"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://example.org"
  spec.metadata["changelog_uri"] = "http://example.org"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "otr-activerecord"
  spec.add_dependency "sqlite3"
  spec.add_dependency "thor"

  spec.add_development_dependency "rspec"
end
