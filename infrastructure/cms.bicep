import { appendHash } from './utilities.bicep'

targetScope = 'subscription'

param environment string
param databaseClient string

var secrets = [
  'APP_KEYS'
  'API_TOKEN_SALT'
  'ADMIN_JWT_SECRET'
  'TRANSFER_TOKEN_SALT'
  'JWT_SECRET'
  'DATABASE_USERNAME'
  'DATABASE_PASSWORD'
]

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
}

module cmsIdentity 'modules/identity.bicep' = {
  scope: resourceGroup
  name: 'deployCmsIdentity'
  params: {
    identityName: 'id-cms'
  }
}

module keyVault 'modules/keyVault.bicep' = {
  scope: resourceGroup
  name: 'deployCmsKeyVault'
  params: {
    keyVaultName: 'kv-cms'
    secrets: secrets
    accessPolicies: [
      {
        objectId: cmsIdentity.outputs.cmsIdentityPrincipalId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
        }
        tenantId: cmsIdentity.outputs.cmsIdentityTenantId
      }
    ]
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
    cmsIdentityResourceId: cmsIdentity.outputs.cmsIdentityResourceId
    environmentVariables: [
      {
        name: 'DATABASE_CLIENT'
        value: databaseClient
      }
    ]
    secrets: secrets
  }
}

output containerRegistryName string = containerRegistry.outputs.containerRegistryName
output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
output resourceGroupName string = resourceGroup.name
output resourceLocation string = resourceGroup.location
