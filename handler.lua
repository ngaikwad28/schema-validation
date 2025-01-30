local cjson = require "cjson"
local base_plugin = require "kong.plugins.base_plugin"
local schema_validator = require "kong.plugins.schema-validation.schema"  -- Import schema validation logic

local SchemaValidationHandler = base_plugin:extend()

-- Constructor for the plugin
function SchemaValidationHandler:new()
  SchemaValidationHandler.super.new(self, "schema-validation")
end

-- This function is triggered during the response phase
function SchemaValidationHandler:body_filter()
  SchemaValidationHandler.super.body_filter(self)

  -- Retrieve the response body
  local response_body = ngx.arg[1]
  if response_body and response_body ~= "" then
    -- Decode the JSON response body
    local decoded_body, err = pcall(cjson.decode, response_body)
    if not decoded_body then
      ngx.log(ngx.ERR, "Failed to decode JSON response body: " .. err)
      return
    end

    -- Perform schema validation
    local is_valid, validation_error = schema_validator.validate_response(decoded_body)
    if not is_valid then
      ngx.status = ngx.HTTP_BAD_REQUEST
      ngx.say(cjson.encode({ message = "Schema validation failed: " .. validation_error }))
      return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
  end
end

-- Define the plugin priority (mandatory)
SchemaValidationHandler.PRIORITY = 10

-- Define the plugin version (mandatory)
SchemaValidationHandler.VERSION = "1.0.0"

return SchemaValidationHandler
