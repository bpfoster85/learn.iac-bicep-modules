param name string
param containerAppEnvironmentId string
param containerImage string

param stateStorageAccountName string
param stateStorageKey string
param stateContainerName string

//@description('ACR username from keyvault')
//@secure()
//param containerRegistryUsername string
@description('ACR password from keyvault')
@secure()
param containerRegistryPassword string

var location = 'eastus2'

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  kind: 'containerapps'
  location: location
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      secrets: [
        //secrets are passed in from pipeline and used throughout deployment
        {
          name: 'acr-password'
          value: containerRegistryPassword
        }
      ]
      registries:[
        {
          server: 'acrverus.azurecr.io'
          username: 'acrverus'
          passwordSecretRef: 'acr-password'
        }
      ]
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
      }
    }
    template: {
      containers: [
        {
          image: 'acrverus.azurecr.io/${containerImage}:latest'
          name: containerImage
          resources: {
            cpu: '.5'
            memory: '1Gi'
          }
          // env: [ //update in project specific app settings
          //   //appsettings for the application of the container
          //   {
          //     name: 'woot'
          //     value: 'value string/secret'
          //   }
          //   {
          //     name: 'woot1'
          //     value: 'value string/secret'
          //   }
          // ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 2
        rules: [
          {
            name: 'http-rule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
      // dapr: {
      //   enabled: true
      //   appPort: 3000
      //   appId: 'nodeapp'
      //   components: [
      //     {
      //       name: 'statestore'
      //       type: 'state.azure.blobstorage'
      //       version: 'v1'
      //       metadata: [
      //         {
      //           name: 'accountName'
      //           value: stateStorageAccountName
      //         }
      //         {
      //           name: 'accountKey'
      //           secretRef: stateStorageKey
      //         }
      //         {
      //           name: 'containerName'
      //           value: stateContainerName
      //         }
      //       ]
      //     }
      //   ]
      // }
    }
  }
}
output fqdn string = containerApp.properties.configuration.ingress.fqdn
