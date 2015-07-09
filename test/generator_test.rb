require "test/unit"
require "mocha/test_unit"

require "roger/cli"
require_relative "../lib/roger_jshint/generator.rb"

# Mock project
class Project
  def path
    "./"
  end
end

# Linting plugin unit test
class GeneratorTest < Test::Unit::TestCase
  #  Check if tasks is added
  def test_default_generator
    assert_includes Roger::Cli::Generate.tasks, "jshint", "Task is loaded"
  end

  def test_create_file
    file_name = "./.jshintrc"
    Roger::Cli::Base.expects(:project).once.returns(Project.new)
    cli = Roger::Cli::Generate.new
    cli.invoke "jshint", [], ["-f"]
    assert File.exist?(file_name), "After invoking the file is written"

    # Unlink file
    File.unlink file_name
  end
end
