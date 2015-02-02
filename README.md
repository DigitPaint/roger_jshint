Roger JSHint
============

[![Build Status](https://travis-ci.org/DigitPaint/roger_jshint.svg)](https://travis-ci.org/DigitPaint/roger_jshint)


Lint JavaScript files from within Roger. This plugin uses [jshint](https://github.com/jshint/jshint). If present, .jshintrc in your project will be used. If not, jshint will walk the directory tree upwards until a .jshintrc file is found. As a last resort, [jshint's default configuration](https://raw.githubusercontent.com/jshint/jshint/master/examples/.jshintrc) is used.

## Installation
* Install jshint using npm: ```npm install jshint -g```

* Add ```gem 'roger_jshint'``` to your Gemfile

* Add this to your Mockupfile:
```
mockup.test do |t|
  t.use :jshint
end
```

* (Optional) put a .jshintrc in your project's root directory.

## Running
Execute ```roger test jshint```.

## License

This project is released under the [MIT license](LICENSE).
