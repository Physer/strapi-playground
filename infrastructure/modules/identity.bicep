import { appendHash } from '../utilities.bicep'

param identityName string

resource cmsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: appendHash(identityName)
  location: resourceGroup().location
}

output resourceId string = cmsIdentity.id
output principalId string = cmsIdentity.properties.principalId
output tenantId string = cmsIdentity.properties.tenantId
output resourceName string = cmsIdentity.name
