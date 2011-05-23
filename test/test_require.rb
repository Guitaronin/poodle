require 'helper'
require 'rubygems/installer_test_case'

class TestRequire < Gem::InstallerTestCase
  def create_gem_module(name)
    "module #{name}; end"    
  end

  def generate_and_install_gem(name, mod_name)
    gem = quick_gem(name, '1')
    mod = create_gem_module(mod_name)
    file = write_file("#{name}/lib/#{name}.rb") { |io| io.write(mod)}
    gem.files = [file]
    util_build_gem(gem)
    install_specs(gem)
    gem
  end


  def test_require_gems_from_gemfile
    generate_and_install_gem("test_gem_1", "TestGem1")
    generate_and_install_gem("test_gem_2", "TestGem2")
    generate_and_install_gem("test_gem_3", "TestGem3")    
    gemfile = "gem('test_gem_1'); gem('test_gem_2'); gem('test_gem_3')"
    Poodle::Require.new(gemfile).execute_gemfile
    
  end  
end
