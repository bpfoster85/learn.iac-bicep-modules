param galleries_acg_core_name string = 'acg_core'

resource galleries_acg_core_name_resource 'Microsoft.Compute/galleries@2021-10-01' = {
  name: galleries_acg_core_name
  location: 'westus3'
  properties: {
    identifier: {}
  }
}