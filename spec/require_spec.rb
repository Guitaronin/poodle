require "helper"

describe Poodle::Require do
  include GemHelpers

  def gemfile
    %{gem("a", :require => "test_gem_file")}
  end
  
  before(:all) do    
    setup_environment
  end

  after(:all) do
    restore_environment
  end
  
  it "should require a bunch of gems" do
    gem_a = quick_gem('a') { |s| s.files = Dir[File.expand_path(".") + "/*"] }
#    gem_b = quick_gem('b') { |s| s.files = ["./test_gem_file.rb"] }
    gem_a_build = Gem::Installer.new(Gem::Builder.new(gem_a).build)
#    gem_b_build = Gem::Installer.new(Gem::Builder.new(gem_b).build)
    
    Poodle::Require.new(gemfile).execute_gemfile
    

    
  end
  
end
