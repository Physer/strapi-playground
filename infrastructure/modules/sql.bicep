import { appendHash } from '../utilities.bicep'

param skuName string = 'Standard_B1ms'
param skuTier string = 'Burstable'
param flexibleMySqlServerLocation string = 'swedencentral'
@secure()
param sqlPassword string
param databaseName string

resource mySql 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: appendHash('mysql-cms')
  location: flexibleMySqlServerLocation
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    version: '8.0.21'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: sqlPassword
  }
}

resource mySqlDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2023-12-30' = {
  parent: mySql
  name: databaseName
}

resource allowAzureServicesToMySql 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-12-30' = {
  parent: mySql
  name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlAdminUser string = mySql.properties.administratorLogin
output hostName string = mySql.properties.fullyQualifiedDomainName
