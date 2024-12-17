import { appendHash } from '../utilities.bicep'

param databaseClient string
param logAnalyticsWorkspaceName string
param keyVaultName string
param identityResourceId string
param cmsImageName string
param cmsInitImageName string = ''

var strapiSqlUser = 'strapi-user'
var mySqlAdminPasswordKeyVaultReference = 'mysql-admin-password'
var cmsSqlPasswordKeyVaultReference = 'database-password'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

module mySql '../modules/sql.bicep' = {
  name: 'deployMysql'
  params: {
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
    keyVaultName: keyVaultName
    targetPort: 1337
    cmsIdentityResourceId: identityResourceId
    environmentVariables: [
      {
        name: 'DATABASE_CLIENT'
        value: databaseClient
      }
      {
        name: 'DaTABASE_NAME'
        value: mySql.outputs.databaseName
      }
      {
        name: 'SQL_ROOT_USER'
        value: 'root'
      }
      {
        name: 'SQL_HOST'
        value: mySql.outputs.hostName
      }
      {
        name: 'DATABASE_USERNAME'
        value: strapiSqlUser
      }
      {
        name: 'SQL_CMS_USER'
        value: strapiSqlUser
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
