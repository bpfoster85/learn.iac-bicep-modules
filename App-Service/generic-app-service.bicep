param webSiteName string
param location string = resourceGroup().location
param appServicePlanId string

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      netFrameworkVersion: 'v6.0'
    }
  }
}


