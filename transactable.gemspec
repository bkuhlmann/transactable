# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "transactable"
  spec.version = "0.1.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/transactable"
  spec.summary = "A DSL for transactional workflows built atop function composition."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/transactable/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/transactable/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/transactable",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Transactable",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/transactable"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"

  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "dry-events", "~> 0.4"
  spec.add_dependency "dry-monads", "~> 1.5"
  spec.add_dependency "infusible", "~> 0.0"
  spec.add_dependency "marameters", "~> 0.9"
  spec.add_dependency "refinements", "~> 9.7"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
