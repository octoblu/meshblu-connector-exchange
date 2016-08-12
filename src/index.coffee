{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-exchange:index')
ews             = require 'ews-javascript-api'

class Connector extends EventEmitter
  constructor: ->
    exchangeVersion = ews.ExchangeVersion.Exchange2010
    @exch = new ews.ExchangeService(exchangeVersion)
    @autod = new ews.AutodiscoverService(exchangeVersion)

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  setEws: () =>
    return unless @options.username?
    @exch.Url = @exch.AutodiscoverUrl(@options.email)
    @exch.Credentials = new ews.ExchangeCredentials(@options.username, @options.password)
    debug 'Exchange Service Credentials Set', @exch

  setAutod: () =>
    return unless @options.username?
    @autod.Credentials = new ews.ExchangeCredentials(@options.username, @options.password);

  GetUserSettings: (userEmails, callback) =>
    settings = [
      ews.UserSettingName.InternalEwsUrl,
      ews.UserSettingName.ExternalEwsUrl,
      ews.UserSettingName.UserDisplayName,
      ews.UserSettingName.UserDN,
      ews.UserSettingName.EwsPartnerUrl,
      ews.UserSettingName.DocumentSharingLocations,
      ews.UserSettingName.MailboxDN,
      ews.UserSettingName.ActiveDirectoryServer,
      ews.UserSettingName.CasVersion,
      ews.UserSettingName.ExternalWebClientUrls,
      ews.UserSettingName.ExternalImap4Connections,
      ews.UserSettingName.AlternateMailboxes
      ]

    @autod.GetUserSettings(userEmails, settings)
    .then((response) =>
      callback response
    )


  FindAppointments: (opts={}, callback) =>
    @exch.FindAppointments()
    .then((response) =>
      callback response
    )

  GetUserAvailability: (emails, callback) =>
    attendee = []
    emails.forEach (email) =>
      attendee.push new (ews.AttendeeInfo)(email)

    timeWindow = new (ews.TimeWindow)(ews.DateTime.Now, new (ews.DateTime)(ews.DateTime.Now.TotalMilliSeconds + ews.TimeSpan.FromHours(48).asMilliseconds()))
    @exch.GetUserAvailability(attendee, timeWindow, ews.AvailabilityData.FreeBusyAndSuggestions).then ((availabilityResponse) =>
      callback availabilityResponse
    ), (errors) ->
      return

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options
    @setEws()
    @setAutod()

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

module.exports = Connector
