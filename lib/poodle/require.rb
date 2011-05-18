module Poodle

  class Require < Gemfile
    def gem(gem_name, version_or_options = { }, options = { })
      super(gem_name, version_or_options, options)
      require(@gem_specific_options[:require] || gem_name)
    end
  end
  
end
