import { appendHash } from '../utilities.bicep'

param skuName string = 'Standard_B1ms'
param skuTier string = 'Burstable'
param storage int = 20
@secure()
param sqlPassword string
param databaseName string

resource postgres 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: appendHash('psql-cms')
  location: resourceGroup().location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    administratorLogin: 'postgresadmin'
    administratorLoginPassword: sqlPassword
    version: '14'
    highAvailability: {
      mode: 'Disabled'
    }
    storage: {
      type: 'PremiumV2_LRS'
      storageSizeGB: storage
      autoGrow: 'Enabled'
    }
    backup: {
      geoRedundantBackup: 'Disabled'
      backupRetentionDays: 7
    }
  }
}

resource postgresDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2024-08-01' = {
  parent: postgres
  name: databaseName
}

resource allowAzureServicesToPostgres 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2024-08-01' = {
  parent: postgres
  name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlAdminUser string = postgres.properties.administratorLogin
output hostName string = postgres.properties.fullyQualifiedDomainName
