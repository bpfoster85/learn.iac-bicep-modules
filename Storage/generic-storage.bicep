param StorageAccountName string
param sku string
param Location string 
param RGName string 
param Kind string = 'StorageV2'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: StorageAccountName
  location: Location
  kind: Kind
  sku:{
    name:sku
  }
}

#disable-next-line outputs-should-not-contain-secrets 
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${StorageAccountName};AccountKey=${listKeys(resourceId(RGName, 'Microsoft.Storage/storageAccounts', StorageAccountName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
