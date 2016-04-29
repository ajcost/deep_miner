# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deep_miner/version'

Gem::Specification.new do |spec|
  spec.name          = "deep_miner"
  spec.version       = DeepMiner::VERSION
  spec.authors       = ["ajcost"]
  spec.email         = ["acost@sas.upenn.edu"]

  spec.summary       = %q{Neural Network Library}
  spec.description   = %q{A library allowing for implementation of neural networks in Ruby}
  spec.homepage      = %q{https://github.com/ajcost/deep_miner}

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
