import { appendHash } from '../utilities.bicep'

param cmsIdentityResourceId string
param cmsIdentityPrincipalId string
param cmsIdentityTenantId string

resource mySql 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: appendHash('mysql-cms')
  location: resourceGroup().location
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
  }
  properties: {
    version: '8.0.21'
  }
}

resource mySqlAdmin 'Microsoft.DBforMySQL/flexibleServers/administrators@2023-12-30' = {
  parent: mySql
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    identityResourceId: cmsIdentityResourceId
    login: 'mysql-cms-admin'
    sid: cmsIdentityPrincipalId
    tenantId: cmsIdentityTenantId
  }
}
