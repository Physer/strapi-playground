import { appendHash } from '../utilities.bicep'

param identityName string

resource cmsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: appendHash(identityName)
  location: resourceGroup().location
}

output cmsIdentityResourceId string = cmsIdentity.id
output cmsIdentityPrincipalId string = cmsIdentity.properties.principalId
output cmsIdentityTenantId string = cmsIdentity.properties.tenantId
output cmsIdentityName string = cmsIdentity.name
