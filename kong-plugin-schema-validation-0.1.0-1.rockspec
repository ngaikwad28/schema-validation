package = "kong-plugin-schema-validation"
version = "0.1.0-1"
rockspec_format = "1.0"
source = {
  url = "git://github.com/yourusername/schema-validation.git",
  branch = "master"
}

dependencies = {
  "kong",
}

description = {
  summary = "A plugin to validate response body against a schema",
  detailed = [[
    This plugin validates the response body against a predefined schema.
  ]],
  license = "MIT",
  author = "Your Name",
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.schema-validation"] = "handler.lua",
    ["kong.plugins.schema-validation.schema"] = "schema.lua",
  }
}
