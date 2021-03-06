param FunctionAppName string
@secure()
param FunctionStorageAccountConnectionString string
param AppInsightsKey string


resource functionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${FunctionAppName}/appsettings'
  properties: {
    
    AzureWebJobsStorage: FunctionStorageAccountConnectionString
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING:        FunctionStorageAccountConnectionString
    WEBSITE_CONTENTSHARE:                            toLower(FunctionAppName)
    FUNCTIONS_EXTENSION_VERSION:                     '~4'
    APPINSIGHTS_INSTRUMENTATIONKEY:                  AppInsightsKey
    FUNCTIONS_WORKER_RUNTIME:                        'dotnet'
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
  }
}
