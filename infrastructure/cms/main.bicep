import { appendHash } from '../utilities.bicep'

param databaseClient string
param logAnalyticsWorkspaceName string
param keyVaultName string
param identityResourceId string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

module mysql '../modules/sql.bicep' = {
  name: 'deployMysql'
  params: {
    sqlPassword: keyVault.getSecret('mysql-admin-password')
  }
}

module cmsContainerApp '../modules/containerApp.bicep' = {
  name: 'deployCmsContainer'
  params: {
    containerAppEnvironmentName: 'cae-cms'
    containerAppName: 'ca-cms'
    imageName: 'nginx:latest'
    logAnalyicsWorkspaceName: logAnalyticsWorkspaceName
    keyVaultName: keyVaultName
    targetPort: 1337
    cmsIdentityResourceId: identityResourceId
    environmentVariables: [
      {
        name: 'DATABASE_CLIENT'
        value: databaseClient
      }
    ]
    secrets: [
      'APP_KEYS'
      'API_TOKEN_SALT'
      'ADMIN_JWT_SECRET'
      'TRANSFER_TOKEN_SALT'
      'JWT_SECRET'
      'DATABASE_USERNAME'
      'DATABASE_PASSWORD'
    ]
  }
}

output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
