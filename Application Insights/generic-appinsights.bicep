param name string
param rgLocation string
param LAWS string = '/subscriptions/dc9bbd18-5243-470b-8b26-319c4ffff550/resourceGroups/DefaultResourceGroup-USW3/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-dc9bbd18-5243-470b-8b26-319c4ffff550-USW3'

resource appIns 'microsoft.insights/components@2020-02-02' = {
  name: name
  location: rgLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    WorkspaceResourceId: LAWS
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output appInsightsKey string = reference(appIns.id, '2014-04-01').InstrumentationKey
