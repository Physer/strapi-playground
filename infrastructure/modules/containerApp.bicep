import { appendHash } from '../utilities.bicep'

param containerAppEnvironmentName string
param containerAppName string
param imageName string
param logAnalyicsWorkspaceName string

param cpu string = '.25'
param memory string = '0.5Gi'
param minReplicas int = 0
param maxReplicas int = 1
param targetPort int = 80

var location = resourceGroup().location

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyicsWorkspaceName
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-08-02-preview' = {
  location: location
  name: appendHash(containerAppEnvironmentName)
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

resource containerApp 'Microsoft.App/containerApps@2024-08-02-preview' = {
  location: location
  name: appendHash(containerAppName)
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: targetPort
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
          name: appendHash(containerAppName)
          image: imageName
          resources: {
            cpu: json(cpu)
            memory: memory
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output containerAppEnvironmentName string = containerAppEnvironment.name
output containerAppName string = containerApp.name
output containerAppIdentityPrincipalId string = containerApp.identity.principalId
