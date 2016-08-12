{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-exchange:index')
ews             = require 'ews-javascript-api'

class Connector extends EventEmitter
  constructor: ->
    exchangeVersion = ews.ExchangeVersion.Exchange2010
    exchangeUrl = "https://autodiscover.citrix.com/"
    @autod = new ews.AutodiscoverService(new ews.Uri(exchangeUrl), exchangeVersion)

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  setEws: () =>
    return unless @options.username?
    @autod.Credentials = new ews.ExchangeCredentials(@options.username, @options.password)
    console.log @autod

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
    console.log @autod
    @autod.FindAppointments()
    .then((response) =>
      callback response
    )

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options
    @setEws()

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

module.exports = Connector
