import { appendHash, makeValidIdentifier } from '../utilities.bicep'

param keyVaultName string
param sku string = 'standard'
param accessPolicies array = []
param secrets array = []

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

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2024-04-01-preview' = [
  for secret in secrets: {
    parent: keyVault
    name: makeValidIdentifier(secret)
    properties: {
      value: '-'
      attributes: {
        enabled: true
      }
    }
  }
]

output resourceName string = keyVault.name
