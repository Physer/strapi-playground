import { appendHash, removeHyphens } from '../utilities.bicep'

param acrSku string = 'Basic'
param principalId string

var acrPushRoleDefinitionId = '8311e382-0749-4cb8-b61a-304f252e45ec'
var acrPushRoleAssignment = guid(principalId, '', resourceGroup().id)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: acrPushRoleAssignment
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPushRoleDefinitionId)
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: removeHyphens(appendHash('acrstrapi'))
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
}

output containerRegistryId string = containerRegistry.id
output containerRegistryName string = containerRegistry.name
