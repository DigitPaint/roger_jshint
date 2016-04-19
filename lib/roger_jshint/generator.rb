require "open-uri"

require "roger/cli/generate"
require "roger/cli/command"
require "roger/generators"

module RogerJsHint
  # Lint configuration retriever
  class Generator < Roger::Generators::Base
    include Thor::Actions
    CONFIG_PATH = ".jshintrc".freeze
    DEFAULT_CONFIG_URL = "https://raw.githubusercontent.com/"\
                         "DigitPaint/javascript/master/linters/jshintrc".freeze

    desc "JsHint generator creates an .jshintrc config file"
    class_option(
      :config,
      type: :string,
      aliases: ["-c"],
      desc: "Optional config file to use takes a path or url, by
             default it uses the company' default"
    )

    class_option(
      :force,
      type: :boolean,
      aliases: ["-f"],
      desc: "Always overwrite the config file"
    )

    # Write config file
    def write_config_file
      config = options[:config] ? open(options[:config]).read : open(DEFAULT_CONFIG_URL).read

      # Create file check if we don't have a conflict or something
      create_file "#{@project.path}/#{CONFIG_PATH}", config, force: options[:force]
    end
  end
end

Roger::Generators.register :jshint, RogerJsHint::Generator
