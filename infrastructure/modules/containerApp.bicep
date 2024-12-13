import { appendHash, makeValidIdentifier } from '../utilities.bicep'

param containerAppEnvironmentName string
param containerAppName string
param imageName string
param logAnalyicsWorkspaceName string

param cpu string = '.25'
param memory string = '0.5Gi'
param minReplicas int = 0
param maxReplicas int = 1
param targetPort int = 80

param environmentVariables array
param secrets array
param keyVaultName string
param cmsIdentityPrincipalId string

var location = resourceGroup().location

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyicsWorkspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: keyVaultName
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

var mappedSecrets = [
  for secret in secrets: {
    name: secret.name
    secretRef: makeValidIdentifier(secret.name)
  }
]
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
      secrets: [
        for secret in secrets: {
          name: makeValidIdentifier(secret.name)
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/${makeValidIdentifier(secret.name)}'
          identity: cmsIdentityPrincipalId
        }
      ]
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
          env: concat(environmentVariables, mappedSecrets)
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
