import { appendHash } from '../utilities.bicep'

var location = resourceGroup().location

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: appendHash('log-strapi-playground')
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output resourceName string = logAnalytics.name
