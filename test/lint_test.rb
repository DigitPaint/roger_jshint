require_relative "../lib/roger_jshint/lint.rb"
require "test/unit"

class TesterStub
  def initialize
    @messages = Array.new
  end

  def log(_, message)
    @messages.push(message)
  end

  def get_messages
    @messages
  end

  def get_files(_,_)
    ['test/test.js']
  end
end

class LintTest < Test::Unit::TestCase
  def test_lint
    faketester = TesterStub.new

    linter = RogerJsHint::Lint.new
    linter.call(faketester, Hash.new)

    messages = faketester.get_messages
    messages.shift

    assert_equal(messages,
      ["test/test.js:1 1: 'x' is not defined.",
       "test/test.js:2 1: 'alert' is not defined.",
       "test/test.js:2 7: 'x' is not defined."])
  end
end
