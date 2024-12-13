import { appendHash } from './utilities.bicep'

targetScope = 'subscription'

param environment string
param databaseClient string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
}

module keyVault 'modules/keyVault.bicep' = {
  scope: resourceGroup
  name: 'deployCmsKeyVault'
  params: {
    keyVaultName: 'kv-cms'
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
    keyVaultName: keyVault.outputs.resourceName
    targetPort: 1337
    environmentVariables: [
      {
        name: 'DATABASE_CLIENT'
        value: databaseClient
      }
    ]
    secrets: [
      {
        name: 'APP_KEYS'
      }
      {
        name: 'API_TOKEN_SALT'
      }
      {
        name: 'ADMIN_JWT_SECRET'
      }
      {
        name: 'TRANSFER_TOKEN_SALT'
      }
      {
        name: 'JWT_SECRET'
      }
      {
        name: 'DATABASE_USERNAME'
      }
      {
        name: 'DATABASE_PASSWORD'
      }
    ]
  }
}

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
output resourceGroupName string = resourceGroup.name
output resourceLocation string = resourceGroup.location
