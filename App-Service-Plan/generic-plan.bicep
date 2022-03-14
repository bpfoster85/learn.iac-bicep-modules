param planName string
param planLocation string = resourceGroup().location
param planSku string ='S1'
param planTier string = 'Standard'

resource asp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name:planName
  location:planLocation
  sku:{
    name:planSku
    tier:planTier
  }
}

output planId string = asp.id
