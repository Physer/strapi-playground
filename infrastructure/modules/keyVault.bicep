import { appendHash, makeValidIdentifier } from '../utilities.bicep'

param keyVaultName string
param sku string = 'standard'
param cmsIdentityPrincipalId string

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: appendHash(keyVaultName)
  location: resourceGroup().location
  properties: {
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enabledForTemplateDeployment: true
    enabledForDeployment: true
  }
}

resource secretsUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(cmsIdentityPrincipalId, resourceGroup().id, keyVault.id)
  properties: {
    principalId: cmsIdentityPrincipalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    )
  }
}

output resourceName string = keyVault.name
