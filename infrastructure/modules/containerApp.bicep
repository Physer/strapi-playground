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

@secure()
param appKeys string = '${newGuid()},${newGuid()}'
@secure()
param apiTokenSalt string = newGuid()
@secure()
param adminJwtSecret string = newGuid()
@secure()
param transferTokenSalt string = newGuid()
@secure()
param jwtSecret string = newGuid()

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
          env: [
            {
              name: 'APP_KEYS'
              value: appKeys
            }
            {
              name: 'API_TOKEN_SALT'
              value: apiTokenSalt
            }
            {
              name: 'ADMIN_JWT_SECRET'
              value: adminJwtSecret
            }
            {
              name: 'TRANSFER_TOKEN_SALT'
              value: transferTokenSalt
            }
            {
              name: 'JWT_SECRET'
              value: jwtSecret
            }
          ]
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
