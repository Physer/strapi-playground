import { appendHash } from '../utilities.bicep'

param sku string = 'standard'

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
