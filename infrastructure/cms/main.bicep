import { appendHash } from '../utilities.bicep'

param databaseClient string
param databaseName string
param databaseCmsUser string
param logAnalyticsWorkspaceName string
param keyVaultName string
param registryName string
param identityName string
param cmsImageName string
param cmsInitImageName string = ''

var mySqlAdminPasswordKeyVaultReference = 'mysql-admin-password'
var cmsSqlPasswordKeyVaultReference = 'database-password'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: registryName
}

resource cmsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: identityName
}

module postgres '../modules/postgres.bicep' = {
  name: 'deployPostgres'
  params: {
    databaseName: databaseName
    sqlPassword: keyVault.getSecret(mySqlAdminPasswordKeyVaultReference)
  }
}

module cmsContainerApp '../modules/containerApp.bicep' = {
  name: 'deployCmsContainer'
  params: {
    containerAppEnvironmentName: 'cae-cms'
    containerAppName: 'ca-cms'
    imageName: cmsImageName
    initImageName: cmsInitImageName
    logAnalyicsWorkspaceName: logAnalyticsWorkspaceName
    targetPort: 1337
    cmsIdentityResourceId: cmsIdentity.id
    keyVaultUri: keyVault.properties.vaultUri
    registryLoginServer: registry.properties.loginServer
    environmentVariables: [
      {
        name: 'DATABASE_CLIENT'
        value: databaseClient
      }
      {
        name: 'DATABASE_HOST'
        value: postgres.outputs.hostName
      }
      {
        name: 'DATABASE_NAME'
        value: databaseName
      }
      {
        name: 'DATABASE_USERNAME'
        value: databaseCmsUser
      }
      {
        name: 'SQL_ROOT_USER'
        value: postgres.outputs.sqlAdminUser
      }
      {
        name: 'SQL_HOST'
        value: postgres.outputs.hostName
      }
      {
        name: 'SQL_CMS_USER'
        value: databaseCmsUser
      }
      {
        name: 'SQL_DATABASE_NAME'
        value: databaseName
      }
    ]
    secrets: [
      {
        appValue: 'APP_KEYS'
        secretName: 'app-keys'
        fromKeyVault: true
      }
      {
        appValue: 'API_TOKEN_SALT'
        secretName: 'api-token-salt'
        fromKeyVault: true
      }
      {
        appValue: 'ADMIN_JWT_SECRET'
        secretName: 'admin-jwt-secret'
        fromKeyVault: true
      }
      {
        appValue: 'TRANSFER_TOKEN_SALT'
        secretName: 'transfer-token-salt'
        fromKeyVault: true
      }
      {
        appValue: 'JWT_SECRET'
        secretName: 'jwt-secret'
        fromKeyVault: true
      }
      {
        appValue: 'DATABASE_PASSWORD'
        secretName: cmsSqlPasswordKeyVaultReference
        fromKeyVault: true
      }
      {
        appValue: 'SQL_ROOT_PASSWORD'
        secretName: mySqlAdminPasswordKeyVaultReference
        fromKeyVault: true
      }
      {
        appValue: 'SQL_CMS_PASSWORD'
        secretName: cmsSqlPasswordKeyVaultReference
        fromKeyVault: true
      }
    ]
  }
}

output containerAppEnvironmentName string = cmsContainerApp.outputs.containerAppEnvironmentName
output containerAppName string = cmsContainerApp.outputs.containerAppName
