# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "transactable"
  spec.version = "0.12.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/transactable"
  spec.summary = "A domain specific language for functionally composable transactional workflows."
  spec.license = "Hippocratic-2.1"

  spec.post_install_message = <<~MESSAGE
    DEPRECATION: The Transactble gem is deprecated and will be fully destroyed on 2025-03-05.
    Please use the Pipeable gem instead: https://alchemists.io/projects/pipeable.
  MESSAGE

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/transactable/issues",
    "changelog_uri" => "https://alchemists.io/projects/transactable/versions",
    "documentation_uri" => "https://alchemists.io/projects/transactable",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Transactable",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/transactable"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.3"

  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "dry-events", "~> 1.0"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "infusible", "~> 3.4"
  spec.add_dependency "marameters", "~> 3.0"
  spec.add_dependency "refinements", "~> 12.1"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
