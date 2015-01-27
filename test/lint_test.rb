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
    ['test/test.js']
  end
end

# Linting plugin unit test
class LintTest < Test::Unit::TestCase
  def test_lint
    faketester = TesterStub.new

    linter = RogerJsHint::Lint.new
    linter.call(faketester, {})

    messages = faketester.messages
    messages.shift

    assert_equal(messages,
                 ["test/test.js:0 0: Bad option: 'subsub'.",
                  "test/test.js:1 1: 'x' is not defined.",
                  "test/test.js:2 1: 'alert' is not defined.",
                  "test/test.js:2 7: 'x' is not defined."])
  end
end
