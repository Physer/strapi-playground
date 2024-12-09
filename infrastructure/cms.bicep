import { appendHash } from './utilities.bicep'

targetScope = 'subscription'

param environment string
param deploymentServicePrincipalId string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
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
  }
}

module deploymentAcrPushRoleAssignment 'modules/registryRoleAssignment.bicep' = {
  scope: resourceGroup
  name: 'deployAcrPushRoleAssignment'
  params: {
    containerRegistryName: containerRegistry.outputs.containerRegistryName
    principalId: deploymentServicePrincipalId
    roleDefinitionId: '8311e382-0749-4cb8-b61a-304f252e45ec'
  }
}

module containerAcrPullRoleAssignment 'modules/registryRoleAssignment.bicep' = {
  scope: resourceGroup
  name: 'deployAcrPullRoleAssignment'
  params: {
    containerRegistryName: containerRegistry.outputs.containerRegistryName
    principalId: cmsContainerApp.outputs.containerAppIdentityPrincipalId
    roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  }
}

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
output resourceGroupName string = resourceGroup.name
output resourceLocation string = resourceGroup.location
