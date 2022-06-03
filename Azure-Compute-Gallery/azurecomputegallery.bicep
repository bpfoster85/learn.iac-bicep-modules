param acg_name string = 'acg_core'
param location string = 'westus3'
param allowSoftDelete bool = true

resource galleries_acg_core_name_resource 'Microsoft.Compute/galleries@2021-10-01' = {
  name: acg_name
  location: location
  properties: {
    identifier: {}
    softDeletePolicy: {
      isSoftDeleteEnabled: allowSoftDelete
    }
  }  
}
