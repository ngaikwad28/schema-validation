local kong = kong
local cjson = require "cjson"
local schema_validator = require "kong.plugins.schema-validation.schema"

describe("Schema Validation Plugin", function()

  it("should validate a valid response body", function()
    -- Valid response body
    local valid_response = {
      user_data = {
        name = "John Doe",
        age = 30
      }
    }

    local is_valid, err = schema_validator.validate_response(valid_response)
    assert.truthy(is_valid)
    assert.is_nil(err)
  end)

  it("should return error for missing 'user_data' field", function()
    -- Invalid response body (missing 'user_data')
    local invalid_response = {}

    local is_valid, err = schema_validator.validate_response(invalid_response)
    assert.falsy(is_valid)
    assert.equals(err, "'user_data' field is missing")
  end)

  it("should return error for invalid 'name' type", function()
    -- Invalid response body (wrong type for 'name')
    local invalid_response = {
      user_data = {
        name = 1234,  -- Invalid type (should be string)
        age = 30
      }
    }

    local is_valid, err = schema_validator.validate_response(invalid_response)
    assert.falsy(is_valid)
    assert.equals(err, "'name' should be a string")
  end)

  it("should return error for invalid 'age' type", function()
    -- Invalid response body (wrong type for 'age')
    local invalid_response = {
      user_data = {
        name = "John Doe",
        age = "thirty"  -- Invalid type (should be number)
      }
    }

    local is_valid, err = schema_validator.validate_response(invalid_response)
    assert.falsy(is_valid)
    assert.equals(err, "'age' should be a number")
  end)

end)
