import { appendHash } from '../utilities.bicep'

param skuName string = 'Standard_B1ms'
param skuTier string = 'Burstable'
param flexibleMySqlServerLocation string = 'swedencentral'
@secure()
param sqlPassword string

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

output databaseName string = mySql.name
output hostName string = mySql.properties.fullyQualifiedDomainName
