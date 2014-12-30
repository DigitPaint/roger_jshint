"use strict";

module.exports = {
  reporter: function (res) {
    var errors = [];

    res.forEach(function (r) {
      var file = r.file;
      var err = r.error;

      errors.push([file, err.line, err.character, err.reason]);
    });

    if (errors) {
      process.stdout.write(JSON.stringify(errors) + "\n");
    }
  }
};