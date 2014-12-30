require 'json'
require 'roger/test'

module RogerJsHint
  # JS linter plugin for Roger
  class Lint
    JSHINT = 'jshint'
    JSHINT_COMMAND = "#{JSHINT} --reporter=" +
                     File.expand_path('jsonreporter.js', File.dirname(__FILE__)) + ' '

    # @param [Hash] options The options
    # @option options [Array] :match Files to match
    # @option options [Array[Regexp]] :skip An array of file regular expressions to specifiy which files to skip.
    def initialize(options = {})
      @options = {
        :match => ['html/**/*.js'],
        :skip => []
      }
      @options.update(options) if options
    end

    def detect_jshint
      `#{JSHINT} -v`
      rescue Errno::ENOENT
        raise 'Could not find jshint. Install jshint using npm.'
    end

    def report(test, file_path, lints)
      success = true
      if lints.empty?
        test.log(self, "No erors in #{file_path}")
      else
        lints.each do |lint|
          test.log(self,
                   "#{lint[0]}:#{lint[1]} " \
                   "#{lint[2]}: #{lint[3]}")
        end
        success = false
      end
      success
    end

    # @param [Hash] options The options
    # @option options [Array] :match Files to match
    # @option options [Array[Regexp]] :skip An array of file regular expressions to specifiy which files to skip.
    def call(test, options)
      options = {}.update(@options).update(options)

      detect_jshint
      test.log(self, 'JS-linting files')

      test.get_files(options[:match], options[:skip]).each do |file_path|
        output = `#{JSHINT_COMMAND} #{file_path}`
        if output.start_with? 'ERROR'
          fail "Could not load file #{file_path}"
        else
          lint = JSON.parse output
          report(test, file_path, lint)
        end
      end
    end
  end
end

Roger::Test.register :jshint, RogerJsHint::Lint
