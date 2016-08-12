http = require 'http'

class GetUserSettings
  constructor: ({@connector}) ->
    throw new Error 'GetUserSettings requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.emails is required') unless data?.emails?
    @connector.GetUserSettings data.emails, (response) =>
      metadata =
        code: 200
        status: http.STATUS_CODES[200]
      data = {
        response: response
      }

      callback null, {metadata, data}

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = GetUserSettings
