param repositoryUrl string
param repositoryBranch string = 'main'

param location string = resourceGroup().location
param skuName string = 'Free'
param skuTier string = 'Free'

param appName string


module staticWebAppModule '../Static-Web-App/generic-swa.bicep' = {
  name: appName
  params: {
    repositoryUrl:    repositoryUrl
    repositoryBranch: repositoryBranch
    location:         location
    skuName:          skuName
    skuTier:          skuTier
    appName:          appName
  }
}
