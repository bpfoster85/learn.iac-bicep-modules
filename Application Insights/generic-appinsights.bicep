param name string
param rgLocation string

resource appIns 'Microsoft.Insights/components@2020-02-02-preview' = {
  name:name
  kind:'web'
  location:rgLocation
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
    Flow_Type:'Bluefield'
  }
}

output appInsightsKey string = reference(appIns.id, '2014-04-01').InstrumentationKey
