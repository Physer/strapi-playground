import { appendHash, removeHyphens } from '../utilities.bicep'

param acrSku string = 'Basic'
param cmsIdentityPrincipalId string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: removeHyphens(appendHash('acrstrapi'))
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
}

resource acrPushRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(cmsIdentityPrincipalId, resourceGroup().id, containerRegistry.id)
  properties: {
    principalId: cmsIdentityPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '8311e382-0749-4cb8-b61a-304f252e45ec')
  }
}

output registryName string = containerRegistry.name
output registryLoginServer string = containerRegistry.properties.loginServer
