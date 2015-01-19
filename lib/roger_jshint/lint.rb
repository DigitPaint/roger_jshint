require 'json'
require 'roger/test'

module RogerJsHint
  # JS linter plugin for Roger
  class Lint
    # @param [Hash] options The options
    # @option options [Array] :match Files to match
    # @option options [Array[Regexp]] :skip Array of regular expressions to skip files
    # @option options [Array] :jshint Jshint command
    def initialize(options = {})
      @options = {
        :match => ['html/**/*.js'],
        :skip => [],
        :jshint => 'jshint'
      }
      @options.update(options) if options

      @jshint_command = "#{@options[:jshint]} --reporter=" +
                        File.expand_path('jsonreporter.js', File.dirname(__FILE__)) + ' '
    end

    def detect_jshint
      detect = system(format('%s -v', Shellwords.escape(@options[:jshint])))
      fail 'Could not find jshint. Install jshint using npm.' unless detect
    end

    def report(test, file_path, lints)
      success = true
      if lints.empty?
        test.log(self, "No erors in #{file_path}")
      else
        lints.each do |lint|
          test.log(self, "#{lint[0]}:#{lint[1]} #{lint[2]}: #{lint[3]}")
        end
        success = false
      end
      success
    end

    # @param [Hash] options The options
    # @option options [Array] :match Files to match
    # @option options [Array[Regexp]] :skip Array of regular expressions to skip files
    def call(test, options)
      options = {}.update(@options).update(options)

      detect_jshint
      test.log(self, 'JS-linting files')

      test.get_files(options[:match], options[:skip]).each do |file_path|
        execute = @jshint_command + ' ' + Shellwords.escape(file_path)
        output = `#{execute}`
        lint = JSON.parse output
        report(test, file_path, lint)
      end
    end
  end
end

Roger::Test.register :jshint, RogerJsHint::Lint
