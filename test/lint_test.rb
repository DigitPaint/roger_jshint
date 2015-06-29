require_relative '../lib/roger_jshint/lint.rb'
require 'test/unit'

# Fake tester to pass into the linter plugin
class TesterStub
  attr_reader :messages

  def initialize
    @messages = []
  end

  def log(_, message)
    @messages.push(message)
  end

  def get_files(_, _)
    ['test/data/test.js']
  end
end

# Linting plugin unit test
class LintTest < Test::Unit::TestCase
  def setup
    @file_name = ".jshintrc"
    assert !File.exist?(@file_name), ".jshintrc file already exists."
    FileUtils.cp("./test/data/jshintrc", "./.jshintrc")
  end

  def test_lint
    faketester = TesterStub.new

    linter = RogerJsHint::Lint.new
    success = linter.call(faketester, {})

    messages = faketester.messages
    messages.shift

    assert_equal(false, success)

    assert_equal(messages,
                 ["test/data/test.js:0 0: Bad option: 'subsub'.",
                  "test/data/test.js:1 1: 'x' is not defined.",
                  "test/data/test.js:2 1: 'alert' is not defined.",
                  "test/data/test.js:2 7: 'x' is not defined."])
  end

  def teardown
    File.unlink @file_name
  end
end
