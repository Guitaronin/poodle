require "rubygems/dependency_installer"

module Poodle

  class Installer < Gemfile

    BASE_OPTIONS = { :ri => false, :rdoc => false}
    
    def execute_gemfile
      instance_exec {
        eval File.read(@gemfile)
      }
    end

    # Options are general Gem::DependencyInstaller options
    def gem(gem_name, version_or_options = { }, options = { })
      super(gem_name, version_or_options, options)      
      @gem_specific_options = Gem::DependencyInstaller::DEFAULT_OPTIONS.merge(BASE_OPTIONS).merge(@gem_specific_options)
      @dependency_installer = Gem::DependencyInstaller.new(@gem_specific_options)
      @dependency_installer.install(gem_name, @gem_specific_options)
    end  
  end
  
end
