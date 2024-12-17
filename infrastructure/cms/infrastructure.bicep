targetScope = 'subscription'

param environment string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
}

module cmsIdentity '../modules/identity.bicep' = {
  scope: resourceGroup
  name: 'deployCmsIdentity'
  params: {
    identityName: 'id-cms'
  }
}

module keyVault '../modules/keyVault.bicep' = {
  scope: resourceGroup
  name: 'deployCmsKeyVault'
  params: {
    keyVaultName: 'kv-cms'
    cmsIdentityPrincipalId: cmsIdentity.outputs.principalId
  }
}

module containerRegistry '../modules/registry.bicep' = {
  scope: resourceGroup
  name: 'deployContainerRegistry'
  params: {
    cmsIdentityPrincipalId: cmsIdentity.outputs.principalId
  }
}

module logAnalyticsWorkspace '../modules/logAnalytics.bicep' = {
  scope: resourceGroup
  name: 'deployLogAnalytics'
}

output resourceGroupName string = resourceGroup.name
output resourceLocation string = resourceGroup.location
output containerRegistryName string = containerRegistry.outputs.registryName
output containerRegistryLoginServer string = containerRegistry.outputs.registryLoginServer
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.outputs.resourceName
output keyVaultName string = keyVault.outputs.resourceName
output identityResourceId string = cmsIdentity.outputs.resourceId
