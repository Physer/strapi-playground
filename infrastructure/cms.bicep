import { appendHash } from './utilities.bicep'

targetScope = 'subscription'

param environment string
@secure()
param secrets object

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
}

module keyVault 'modules/keyVault.bicep' = {
  scope: resourceGroup
  name: 'deployKeyVault'
  params: {
    secrets: secrets
  }
}

module containerRegistry 'modules/registry.bicep' = {
  scope: resourceGroup
  name: 'deployContainerRegistry'
}

module logAnalyticsWorkspace 'modules/logAnalytics.bicep' = {
  scope: resourceGroup
  name: 'deployLogAnalytics'
}

module cmsContainerApp 'modules/containerApp.bicep' = {
  scope: resourceGroup
  name: 'deployCmsContainer'
  params: {
    containerAppEnvironmentName: 'cae-cms'
    containerAppName: 'ca-cms'
    imageName: 'nginx:latest'
    logAnalyicsWorkspaceName: logAnalyticsWorkspace.outputs.resourceName
    targetPort: 1337
  }
}

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
output resourceGroupName string = resourceGroup.name
output resourceLocation string = resourceGroup.location
