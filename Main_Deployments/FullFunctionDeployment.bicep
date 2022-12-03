param FunctionAppName string
param KeyVaultName string
param SubscriptionId string
param Location string
param KeyVaultRGName string


@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param StorageAccountName string = 'tbd'


var functionAppName = toLower(FunctionAppName)
var keyVaultName = KeyVaultName
var subscriptionId = SubscriptionId
var storageAccountName = toLower(StorageAccountName)
var kvSecretName = 'toLower(StorageAccountName)ConnectionString'

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(subscriptionId, KeyVaultRGName )
}

module storageAccountModule '../Storage/generic-storage.bicep' = {
  name: storageAccountName
  params: {    
    StorageAccountName: storageAccountName
    sku:                'Standard_GRS'
    Location:Location
    RGName: resourceGroup().name
  }
  dependsOn:[
   kv
  ]
}

// ========== add-secret-to-existing-kv ==========
resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${KeyVaultName}/${kvSecretName}'  
  properties: {
    value: storageAccountModule.outputs.storageConnectionString
  }
  dependsOn:[
    storageAccountModule
  ]
}

module appInsightsModule '../Application Insights/generic-appinsights.bicep' = {
  name:'appi-${functionAppName}'
  params:{
    name:'appi-${functionAppName}'
    rgLocation:Location
  }
}

module aspModule '../App-Service-Plan/generic-plan.bicep' = {
  name:'asp-${functionAppName}'
  params:{
    planName: 'asp-${functionAppName}'
    Location: Location
  }
}

module functionAppModule '../function/generic-functionapp.bicep' = {
  name: functionAppName
  params:{
    Location:        Location
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
    FunctionStorageAccountConnectionString: kv.getSecret(kvSecretName) 
    AppInsightsKey:                         appInsightsModule.outputs.appInsightsKey
  }  
  dependsOn:[
    functionAppModule
    appInsightsModule
  ]
}

