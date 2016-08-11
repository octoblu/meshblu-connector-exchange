{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-exchange:index')
ews             = require 'ews-javascript-api'

class Connector extends EventEmitter
  constructor: ->
    exchangeVersion = ews.ExchangeVersion.Exchange2010
    exchangeUrl = "https://autodiscover-s.outlook.com/autodiscover/autodiscover.svc"
    @autod = new ews.AutodiscoverService(new ews.Uri(exchangeUrl), exchangeVersion)

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  setEws: () =>
    @autod.Credentials = new ews.ExchangeCredentials(@options.username, @options.password)

  getUserSettings: (userEmails) =>
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
    .then(response) =>
      console.log response

    FindAppointments: (opts={}) =>
      @autod.FindAppointments()
      .then(response) =>
        console.log response

  onConfig: (device={}) =>
    { @options } = device
    debug 'on config', @options
    @setEws()

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

module.exports = Connector
