# This is a really really simplified version of what is found in rubygems itself.

require "rubygems/mock_gem_ui"
require "rubygems/specification"
require "tmpdir"

module Gem
  def self.searcher=(searcher)
    @searcher = searcher
  end


end

module GemHelpers

  # Sets up a sandbox environment for rubygems to be installed and manipulated from in a tmp directory.
  def setup_environment
    @@project_dir = Dir.pwd
    @orig_gem_home = ENV['GEM_HOME']
    @orig_gem_path = ENV['GEM_PATH']
    @orig_load_path = $LOAD_PATH.dup
    @orig_env_home  = ENV['HOME']

    @ui = Gem::MockGemUi.new


    tmpdir = Dir.tmpdir
    @tempdir = File.join(tmpdir, "test_rubygems_#{$$}")
    @tempdir.untaint
    @gemhome = File.join(@tempdir, 'gemhome')
    @userhome = File.join(@tempdir, 'userhome')

    @orig_ruby = if ruby = ENV['RUBY']
                   Gem.class_eval { ruby, @ruby = @ruby, ruby }
                   ruby
                 end

    Gem.ensure_gem_subdirectories @gemhome

    $LOAD_PATH.map! { |s| File.expand_path(s) }

    Dir.chdir(@tempdir)

    ENV['HOME'] = @userhome

    Gem.instance_variable_set :@user_home, nil

    FileUtils.mkdir_p @gemhome
    FileUtils.mkdir_p @userhome

    Gem.use_paths(@gemhome)

    Gem.loaded_specs.clear
    Gem.unresolved_deps.clear

    Gem.configuration.verbose = true
    Gem.configuration.update_sources = true

    @gem_repo = "http://gems.example.com/"
    @uri = URI.parse @gem_repo
    Gem.sources.replace [@gem_repo]

    Gem.searcher = nil
    Gem::SpecFetcher.fetcher = nil

    @orig_BASERUBY = Gem::ConfigMap[:BASERUBY]
    Gem::ConfigMap[:BASERUBY] = Gem::ConfigMap[:ruby_install_name]

    @orig_arch = Gem::ConfigMap[:arch]
    @marshal_version = "#{Marshal::MAJOR_VERSION}.#{Marshal::MINOR_VERSION}"

    # TODO: move to installer test cases
    Gem.post_build_hooks.clear
    Gem.post_install_hooks.clear
    Gem.post_uninstall_hooks.clear
    Gem.pre_install_hooks.clear
    Gem.pre_uninstall_hooks.clear

    # TODO: move to installer test cases
    Gem.post_build do |installer|
      @post_build_hook_arg = installer
      true
    end

    Gem.post_install do |installer|
      @post_install_hook_arg = installer
    end

    Gem.post_uninstall do |uninstaller|
      @post_uninstall_hook_arg = uninstaller
    end

    Gem.pre_install do |installer|
      @pre_install_hook_arg = installer
      true
    end

    Gem.pre_uninstall do |uninstaller|
      @pre_uninstall_hook_arg = uninstaller
    end    
  end


  # Restores the environment to the pre-test state.
  def restore_environment
    $LOAD_PATH.replace @orig_load_path

    Gem::ConfigMap[:BASERUBY] = @orig_BASERUBY
    Gem::ConfigMap[:arch] = @orig_arch

#    if defined? Gem::RemoteFetcher then
#      Gem::RemoteFetcher.fetcher = nil
#   end

    Dir.chdir @@project_dir

    FileUtils.rm_rf @tempdir unless ENV['KEEP_FILES']

    ENV['GEM_HOME'] = @orig_gem_home
    ENV['GEM_PATH'] = @orig_gem_path

    _ = @orig_ruby
    Gem.class_eval { @ruby = _ } if _

    if @orig_ENV_HOME then
      ENV['HOME'] = @orig_env_home
    else
      ENV.delete 'HOME'
    end
  end

  def write_file(path)
    path = File.join @gemhome, path unless Pathname.new(path).absolute?
    dir = File.dirname path
    FileUtils.mkdir_p dir

    open path, 'wb' do |io|
      yield io if block_given?
    end

    path
  end

  # hack since Gem::Specification somehow doesn't have spec_dir and spec_file
  def spec_file_paths(name, spec)
    @base_dir ||= Gem.dir unless spec.loaded_from
    @base_dir ||= File.dirname File.dirname spec.loaded_from
    @spec_dir ||= File.join(@base_dir, "specifications")
    @spec_file ||= File.join(@spec_dir, "#{name}.gemspec")
  end

  def spec_for_cache(spec)
    new_spec = spec.dup
    new_spec.files = nil
    new_spec.test_files = nil
    new_spec
  end
  
  # Create a gem specification that is modifiable through a block
  def quick_gem(gem_name, version = '1')
    spec = Gem::Specification.new do |s|
      s.platform = Gem::Platform::RUBY
      s.name     = gem_name
      s.version  = version
      s.author   = ["An author"]
      s.email    = 'example@example.com'
      s.homepage = 'http://example.com'
      s.summary  = 'A summary'
      s.description = 'Description'

      yield(s) if block_given?
    end

    # @spec_dir ||= File.join(base_)
    # @spec_file ||= File.join
    spec_file_paths(gem_name, spec)
    
    written_path = write_file @spec_file do |io|
      io.write spec.to_ruby_for_cache
    end

    spec.loaded_from = spec.loaded_from = written_path

    Gem::Specification.add_spec(spec.for_cache)

    spec    
  end

  
end
