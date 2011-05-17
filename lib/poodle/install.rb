require "rubygems/dependency_installer"

module Poodle

  class Installer

    BASE_OPTIONS = { :ri => false, :rdoc => false}
    
    def initialize(gemfile)
      @gemfile = gemfile
    end

    def execute_gemfile
      instance_exec {
        eval File.read(@gemfile)
      }
    end

    # Options are general Gem::DependencyInstaller options
    def gem(gem_name, options = { })
      options[:generate_ri] = options.delete(:ri) if options[:ri]
      options[:generate_rdoc] = options.delete(:rdoc) if options[:rdoc]
      options = Gem::DependencyInstaller::DEFAULT_OPTIONS.merge(BASE_OPTIONS).merge(options)
      @dependency_installer = Gem::DependencyInstaller.new(options)
      @dependency_installer.install(gem_name, options)
    end

    def group(*env, &block)
      if is_in_env?(env)
        instance_exec block
      end
    end

    def source(url)
    end


    private

    def is_in_env?(env)
      env.any? { |e| e == ENV["RAILS_ENV"] } ||
        env.any? { |e| e == ENV["RACK_ENV"] } ||
        env.any? { |e| e == ENV["POODLE_ENV"] }
    end
    
  end
  
end
