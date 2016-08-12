http = require 'http'

class GetUserAvailability
  constructor: ({@connector}) ->
    throw new Error 'GetUserAvailability requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.emails is required') unless data?.emails?
    @connector.GetUserAvailability data.emails, (response) =>
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

module.exports = GetUserAvailability
