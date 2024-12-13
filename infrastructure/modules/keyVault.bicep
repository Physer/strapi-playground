import { appendHash } from '../utilities.bicep'

param keyVaultName string
param sku string = 'standard'
param accessPolicies array = []

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: appendHash(keyVaultName)
  location: resourceGroup().location
  properties: {
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: accessPolicies
  }
}

output resourceName string = keyVault.name
