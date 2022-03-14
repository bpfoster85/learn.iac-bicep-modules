
param KeyVaultName string
param SubscriptionId string

@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param StorageAccountName string = ''

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
