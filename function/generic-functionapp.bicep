param Location string
param FunctionAppName string
param PlanName string

resource functionAppResource 'Microsoft.Web/sites@2020-12-01' = {
  name: FunctionAppName
  identity:{
    type:'SystemAssigned'    
  }
  location: Location
  kind: 'functionapp'
  properties: {
    serverFarmId: PlanName
  }
}

output prodFunctionAppName string = functionAppResource.name
output productionTenantId string = functionAppResource.identity.tenantId
output productionPrincipalId string = functionAppResource.identity.principalId
