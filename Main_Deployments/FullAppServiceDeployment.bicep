param name string
param location string

module appServicePlanModule '../App-Service-Plan/generic-plan.bicep' = {
  name: 'appServicePlan'
  params: {
    planName:'asp-${name}'
    
  }
}

module appServiceModule '../App-Service/generic-app-service.bicep' = {
  name:'appService'
  params:{
    webSiteName: 'as-${name}'
    appServicePlanId: appServicePlanModule.outputs.planId
    
  }
}
