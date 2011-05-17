module Poodle

  class Cli

    def initialize(args)

      @options = { }
      OptionParser.new do |opts|
        opts.banner = "Usage: poodle [options]"

        opts.on("-i", "--install", "Install gems from Gemfile") do |v|
          @options[:install] = true
        end

        opts.on("-g", "--gemfile", "Use this Gemfile instead of what is in #{Dir.pwd}") do |v|
          @options[:gemfile] = v
        end

        opts.on("-d", "--[no]-dry-run", "Just show what is going to happen. (NOT IMPLEMENTED)") do |v|
          @options[:dry_run] = v
        end
      end.parse!

      if @options[:install]
        install
      end
    end


    def install
      gemfile = @options[:gemfile] ? @options[:gemfile] : File.dirname(__FILE__) + "/Gemfile"
      poodle = Poodle::Install.new(gemfile)
      poodle.execute_gemfile
    end
    
  end
  
end
