import { appendHash } from './utilities.bicep'

var location = resourceGroup().location
var containerAppName = appendHash('ca-strapi')

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: appendHash('log-strapi-playground')
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-08-02-preview' = {
  location: location
  name: appendHash('cae-strapi-playground')
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

resource cmsContainerApp 'Microsoft.App/containerApps@2024-08-02-preview' = {
  location: location
  name: containerAppName
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: 'nginx:latest'
          resources: {
            cpu: json('.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}
