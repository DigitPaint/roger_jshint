require "shellwords"
require "json"
require "roger/test"

module RogerJsHint
  # JS linter plugin for Roger
  class Lint
    # @param [Hash] options The options
    # @option options [Array] :match Files to match
    # @option options [Array[Regexp]] :skip Array of regular expressions to skip files
    # @option options [Array] :jshint Jshint command
    def initialize(options = {})
      @options = {
        match: ["html/**/*.js"],
        skip: [],
        jshint: "jshint"
      }

      @options.update(options) if options
    end

    def report(test, file_path)
      command = [
        @options[:jshint],
        reporter
      ]

      # The actual linting
      output = `#{Shellwords.join(command + [Shellwords.escape(file_path)])}`
      lints = JSON.parse output

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
      detect_jshint

      options = {}.update(@options).update(options)

      test.log(self, "JS-linting files")

      failures = test.get_files(options[:match], options[:skip]).select do |file_path|
        !report(test, file_path)
      end
      failures.empty?
    end

    private

    def detect_jshint
      command = [@options[:jshint], "-v", "2>/dev/null"]
      detect = system(Shellwords.join(command))
      raise "Could not find jshint. Install jshint using npm." unless detect
    end

    def reporter
      "--reporter=" + File.expand_path("jsonreporter.js", File.dirname(__FILE__))
    end
  end
end

Roger::Test.register :jshint, RogerJsHint::Lint
