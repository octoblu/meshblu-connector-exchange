http = require 'http'

class FindAppointments
  constructor: ({@connector}) ->
    throw new Error 'FindAppointments requires connector' unless @connector?

  do: ({data}, callback) =>
    # return callback @_userError(422, 'data.example is required') unless data?.example?
    @connector.FindAppointments (response) =>
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

module.exports = FindAppointments
