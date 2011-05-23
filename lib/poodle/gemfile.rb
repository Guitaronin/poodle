module Poodle

  class Gemfile

    # The gemfile is the path to the Gemfile. 'options' is a global user provided set of options.    
    def initialize(gemfile, options = { })
      @gemfile = gemfile
      @user_options = options
    end

    def execute_gemfile
      instance_exec {
        begin
          eval @gemfile
        rescue
          eval File.read(@gemfile)
        end
      }
    end

    # Merges options passed in to provide one single reference for option data.
    # Intended to be used by subclasses.
    
    def gem(gem_name, version_or_options = { }, options = { })
      if version_or_options.is_a? String
        options[:version] = version_or_options
      else
        options.merge!(version_or_options)
      end
      
      options[:generate_ri] = options.delete(:ri) if options[:ri]
      options[:generate_rdoc] = options.delete(:rdoc) if options[:rdoc]

      @gem_specific_options = options.merge(@user_options)
    end

    # Run commands within a specific environment. Any number of environments, listed
    # as symbols can be provided.
    
    def group(*env, &block)
      if is_in_env?(env)
        instance_exec &block
      end
    end

    # Provides a url for RubyGems to search.
    
    def source(url)
    end

    private

    def is_in_env?(env)
      env.any? { |e| ENV["RAILS_ENV"] && e.to_sym == ENV["RAILS_ENV"].to_sym } ||
        env.any? { |e| ENV["RACK_ENV"] && e.to_sym == ENV["RACK_ENV"].to_sym } ||
        env.any? { |e| ENV["POODLE_ENV"] && e.to_sym == ENV["POODLE_ENV"].to_sym } ||
        env.any? { |e| @user_options[:environment] && e == @user_options[:environment].to_sym }
    end
    
  end
  
end
