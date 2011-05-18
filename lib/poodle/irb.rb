require "irb"

module Poodle
  class Irb < Require

    def execute_gemfile
      super
      IRB.start
    end
    
  end
end
