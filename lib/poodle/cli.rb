module Poodle

  class CLI

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

        opts.on("-e" "--environment", "Install gems from an environment") do |v|
          @options[:environment] = v
        end

        # opts.on("-u", "--update", "Update specific gems or all gems in gemfile") do |v|
        #   @options[:update] = v
        # end

        opts.on("-c", "--console", "Open a irb session with your required gems") do |v|
          @options[:console] = v
        end
        
      end.parse!

      if @options[:install]
        install
      elsif @options[:console]
        irb
      end
    end


    def install
      gemfile = determine_gemfile_path
      poodle = Poodle::Installer.new(gemfile, @options)
      poodle.execute_gemfile
    end

    def irb
      gemfile = determine_gemfile_path
      poodle  = Poodle::Irb.new(gemfile, @options)
      poodle.execute_gemfile
    end

    def determine_gemfile_path
      @options[:gemfile] ? @options[:gemfile] : File.join(Dir.pwd, "Gemfile")
    end
    
  end
  
end
