//import ews module
var ews = require('ews-javascript-api');
//create AutodiscoverService object
var autod = new ews.AutodiscoverService(new ews.Uri("https://autodiscover.citrix.com/"), ews.ExchangeVersion.Exchange2010);
//you can omit url and it will autodiscover the url, version helps throw error on client side for unsupported operations.example - //var autod = new ews.AutodiscoverService(ews.ExchangeVersion.Exchange2010);
//set credential for service
autod.Credentials = new ews.ExchangeCredentials("", "");
//create array to include list of desired settings
var settings = [
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
];

//get the setting
autod.GetUserSettings([""], settings)
.then(function (response) {
    //do what you want with user settings
    var tabcount = 0;
    var tabs = function () { return ews.StringHelper.Repeat("\t", tabcount); };
    console.log(autod.Url.ToString());
    //uncoment next line to see full response from autodiscover, you will need to add var util = require('util');
    //console.log(util.inspect(response, { showHidden: false, depth: null, colors: true }));
    for (var _i = 0, _a = response.Responses; _i < _a.length; _i++) {
        var resp = _a[_i];
        console.log(ews.StringHelper.Format("{0}settings for email: {1}", tabs(), resp.SmtpAddress));
        tabcount++;
        for (var setting in resp.Settings) {
            console.log(ews.StringHelper.Format("{0}{1} = {2}", tabs(), ews.UserSettingName[setting], resp.Settings[setting]));
        }
        tabcount--;
    }
}, function (e) {
    //log errors or do something with errors
});
