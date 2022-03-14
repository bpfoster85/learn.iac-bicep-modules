param Location string
param KeyVaultName string
param PrincipalId string
param TenantId string

@secure()
param storageConnectionString string

resource keyVault 'Microsoft.KeyVault/vaults@2016-10-01' = {
  name: KeyVaultName
  location: Location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: TenantId
    accessPolicies: [
      {
        tenantId: TenantId
        objectId: PrincipalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
      
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }  
}


resource CosmosDBEndpointURLSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${KeyVaultName}/CosmosDBEndpointURL'
  properties: {
    value: storageConnectionString
  }
  dependsOn:[
    keyVault
  ]
}



