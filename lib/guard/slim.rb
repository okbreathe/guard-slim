require "slim"
require "fileutils"
require 'guard/compat/plugin'

require_relative "slim/template"
require_relative "slim/template_renderer"

module Guard
  class Slim < Plugin
    NullContext = Struct.new(:template)

    DEFAULTS = {
      :all_on_start => false,
      :input        => "templates",
      :output       => "public",
      :context      => nil,
      :extension    => "html",
      :slim_options => {}
    }.freeze

    # Initializes a Guard plugin.
    # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super(DEFAULTS.merge(options))
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      run_all if @options[:all_on_start]
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      run_on_modifications(Watcher.match_files(self, Dir.glob(File.join('**', '*.*'))))
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
      paths.each { |path| compile(path) }
    end

    def context
      @options[:context] || NullContext
    end

    private

    def compile(path)
      content     = render(path)
      output_path = output_path(path)

      File.open(output_path, "w") { |file| file.puts(content) }

      UI.info "Guard::Slim: Rendered #{path} to #{output_path}"
    end

    def render(input_path)
      template = Template.new(input_path)
      TemplateRenderer.new(template).render(context, @options[:slim_options])
    end

    def output_path(input_path)
      path    = File.expand_path(input_path).sub(@options[:input], @options[:output])
      dirname = File.dirname(path)

      FileUtils.mkpath(dirname) unless File.directory?(dirname)

      basename = File.basename(path, '.slim')
      basename << ".#{@options[:extension]}" if File.extname(basename).empty?

      File.join(dirname, basename)
    end
  end
end

