
param containerAppEnvName string 
param containerAppName string 
param containerImage string
param subscriptionId string

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'kv-verus-core'
  scope: resourceGroup(subscriptionId, resourceGroup().name )
}
resource law  'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' existing = {
  name: 'law-${containerAppEnvName}'
  scope: resourceGroup(subscriptionId, resourceGroup().name )
}
resource containerAppEnvironment  'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: containerAppEnvName
  scope: resourceGroup(subscriptionId, resourceGroup().name )
}
resource stateStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01'  existing = {
  name: 'stcadaprlogs'
  scope: resourceGroup(subscriptionId, resourceGroup().name )
}

module containerApp '../Container App/generic-containerapp.bicep' = {
  name: containerAppName
  params: {
    name: containerAppName
    containerAppEnvironmentId: containerAppEnvironment.id
    containerImage: containerImage
    stateStorageAccountName: stateStorageAccount.name
    stateStorageKey: stateStorageAccount.listKeys().keys[0].value
    stateContainerName: 'daprlogs'
    //containerRegistryUsername: kv.getSecret('ACRUsername')
    containerRegistryPassword: kv.getSecret('ACRPassword')
  }
}
output fqdn string = containerApp.outputs.fqdn
