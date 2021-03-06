lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "moodwall/version"

Gem::Specification.new do |spec|
  spec.name          = "moodwall"
  spec.version       = Moodwall::VERSION
  spec.authors       = ["Valiantsin Mikhaliuk"]
  spec.email         = ["valiantsin.mikhaliuk@gmail.com"]

  spec.summary       = %q{Change wallpapers randomly depending on the moods.}
  spec.homepage      = "https://github.com/vmikhaliuk/moodwall"
  spec.license       = "GPL-3.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|assets)/}) }
  end
  spec.executables   = %w[moodwall]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
end
