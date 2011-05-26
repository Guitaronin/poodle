lib = File.expand_path("lib")
$:.unshift lib unless $:.include?(lib)

require 'poodle/version'

Gem::Specification.new do |gem|
  gem.name                       = "poodle"
  gem.homepage                   = "http://github.com/bolsen/poodle"
  gem.license                    = "MIT"
  gem.summary                    = %Q{Dead simple gem management}
  gem.description                = %Q{Like Bundler, but tries to be as simple as possible, depending on other tools like RubyGems and RVM to install and load gems.}
  gem.email                      = "brian@bolsen.org"
  gem.authors                    = ["Brian Olsen"]
  gem.version                    = Poodle::VERSION

  gem.post_install_message       = "Woof! Woof!"
  gem.files                      = Dir.glob("{bin,lib}/**/*") + %w{LICENSE.txt README.rdoc}
  gem.required_rubygems_version  = ">= 1.3.6"
  gem.executables                = ['poodle']
  
  gem.add_development_dependency 'rspec'
end
