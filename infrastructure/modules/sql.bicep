import { appendHash } from '../utilities.bicep'

param cmsIdentityResourceId string
param cmsIdentityPrincipalId string
param cmsIdentityTenantId string
param cmsIdentityName string
param flexibleMySqlServerLocation string = 'germanynorth'
@secure()
param sqlPassword string = newGuid()

resource mySql 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: appendHash('mysql-cms')
  location: flexibleMySqlServerLocation
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '8.0.21'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: sqlPassword
  }
}

resource mySqlAdmin 'Microsoft.DBforMySQL/flexibleServers/administrators@2023-12-30' = {
  parent: mySql
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: cmsIdentityName
    identityResourceId: cmsIdentityResourceId
    sid: cmsIdentityPrincipalId
    tenantId: cmsIdentityTenantId
  }
}
