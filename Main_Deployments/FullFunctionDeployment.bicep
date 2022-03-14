param FunctionAppName string
param KeyVaultName string
param SubscriptionId string

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param StorageAccountName string = 'tbd'
param location string = resourceGroup().location

var functionAppName = toLower(FunctionAppName)
var keyVaultName = KeyVaultName
var subscriptionId = SubscriptionId
var storageAccountName = toLower(StorageAccountName)

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(subscriptionId, resourceGroup().name )
}

module storageAccountModule '../Storage/generic-storage.bicep' = {
  name: storageAccountName
  params: {
    KeyVaultName:       keyVaultName
    StorageAccountName: storageAccountName
    sku:                'Standard_GRS'
  }
}

module appInsightsModule '../Application Insights/generic-appinsights.bicep' = {
  name:'appi-${functionAppName}'
  params:{
    name:'appi-${functionAppName}'
  }
}

module aspModule '../App Service Plan/consumption-plan.bicep' = {
  name:'asp-${functionAppName}'
  params:{
    planName:     'asp-${functionAppName}'
    planLocation: location
  }
}

module functionAppModule '../function/generic-functionapp.bicep' = {
  name: functionAppName
  params:{
    Location:        resourceGroup().location
    FunctionAppName: functionAppName
    PlanName:        aspModule.outputs.planId
  }
  dependsOn:[
    storageAccountModule
    aspModule
  ] 
}

module functionAppSettingsModule '../function/generic-function-appsettings.bicep' = {
  name: 'functionAppSettings-${functionAppName}'
  params: {
    FunctionAppName:                        functionAppName
    FunctionStorageAccountConnectionString: kv.getSecret('${storageAccountName}ConnectionString') 
    AppInsightsKey:                         appInsightsModule.outputs.appInsightsKey
    VideoStorageConnectionString:           kv.getSecret('stvsvideouploadqueueConnectionString') 
    VideoStorageContainerName:              kv.getSecret('VideoStorageContainerName')   
    VideoQueueConnectionString:             kv.getSecret('stvsvideouploadqueueConnectionString')
    VideoQueueName:                         kv.getSecret('VideoQueueName')  
    CosmosDBKey:                            kv.getSecret('CosmosDBKey')       
    CosmosDBEndpointURL:                    kv.getSecret('CosmosDBEndpointURL') 
  }  
  dependsOn:[
    functionAppModule
    appInsightsModule
  ]
}

