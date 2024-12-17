import { appendHash } from '../utilities.bicep'

param identityName string

resource cmsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: appendHash(identityName)
  location: resourceGroup().location
}

output name string = cmsIdentity.name
output principalId string = cmsIdentity.properties.principalId
