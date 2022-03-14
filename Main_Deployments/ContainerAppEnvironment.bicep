
param containerAppEnvName string 

var ContainerLocation = 'eastus2' //needed because the resource is in preview and limited to specific regions

module law '../Log-Analytics/generic-loganalytics.bicep' = {
    name: 'log-analytics-workspace'
    params: {
      location: ContainerLocation
      name: 'law-${containerAppEnvName}'
    }
}

module containerAppEnvironment '../Container-App/generic-containerapp-environment.bicep' = {
  name: 'container-app-environment'
  params: {
    name: containerAppEnvName
    location: ContainerLocation
    lawClientId:law.outputs.clientId
    lawClientSecret: law.outputs.clientSecret
  }
}

