param StorageAccountName string
param sku string
param Location string 
param RGName string 
param Kind string = 'StorageV2'
param KeyVaultName string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: StorageAccountName
  location: Location
  kind: Kind
  sku:{
    name:sku
  }
}

// ========== add-secret-to-existing-kv ==========

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${KeyVaultName}/${StorageAccountName}ConnectionString'  
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAccountName};AccountKey=${listKeys(resourceId(RGName, 'Microsoft.Storage/storageAccounts', StorageAccountName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
  }
  dependsOn:[
    storageAccount
  ]
}
