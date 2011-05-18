module Poodle
  require "poodle/gemfile"
  require "poodle/install"
  #  require "poodle/update"
  
  require "poodle/require"
  require "poodle/cli"
  require "poodle/irb"
  
  def require(*env)
    Poodle::Require.new(determine_gemfile_path, :environments => env).execute
  end

  def determine_gemfile_path
    Poodle::CLI.new(ARGV).determine_gemfile_path
  end
  
end
