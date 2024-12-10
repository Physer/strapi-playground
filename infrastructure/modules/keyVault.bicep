import { appendHash } from '../utilities.bicep'

param sku string = 'standard'
@secure()
param secrets object

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: appendHash('kv-strapi-playground')
  location: resourceGroup().location
  properties: {
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2024-04-01-preview' = [
  for secret in items(secrets): {
    parent: keyVault
    name: secret.key
    properties: {
      attributes: {
        enabled: true
      }
      value: secret.value
    }
  }
]
