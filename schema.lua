local _M = {}

-- Define the schema for user_data field
_M.user_data_schema = {
  type = "object",
  required = { "name", "age" },
  properties = {
    name = { type = "string" },
    age = { type = "number" }
  }
}

-- Function to validate the response body
function _M.validate_response(response_body)
  local user_data = response_body.user_data

  if not user_data then
    return false, "'user_data' field is missing"
  end

  -- Validate 'name' field
  if type(user_data.name) ~= "string" then
    return false, "'name' should be a string"
  end

  -- Validate 'age' field
  if type(user_data.age) ~= "number" then
    return false, "'age' should be a number"
  end

  return true
end

return _M
