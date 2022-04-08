param planName string
param Location string
param planSku string ='S1'
param planTier string = 'Standard'

resource asp 'Microsoft.Web/serverfarms@2020-12-01' = {
  name:planName
  location: Location
  sku:{
    name:planSku
    tier:planTier
  }
}

output planId string = asp.id
