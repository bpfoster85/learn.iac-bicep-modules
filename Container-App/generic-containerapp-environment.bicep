param name string
param location string = 'eastus2'
param lawClientId string
param lawClientSecret string

resource env 'Microsoft.Web/kubeEnvironments@2021-03-01' = {
  name: name
  location: location
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: true
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: lawClientId
        sharedKey: lawClientSecret
      }
    }
  }
}
output id string = env.id
