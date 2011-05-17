module Poodle

  class Require

    def initialize(gemfile)
      @gemfile = gemfile
    end
    
    def execute_gemfile
      instance_exec {
        eval File.read(@gemfile)
      }
    end

    def gem(gem_name, options = { })
      Kernel.require(options[:require] || gem_name)
    end

    def source(url)
    end

    def group(*env)
    end
    
  end
  
end
