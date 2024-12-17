import { appendHash, makeValidIdentifier } from '../utilities.bicep'

param containerAppEnvironmentName string
param containerAppName string
param imageName string
param initImageName string
param logAnalyicsWorkspaceName string

param cpu string = '.25'
param memory string = '0.5Gi'
param minReplicas int = 0
param maxReplicas int = 1
param targetPort int = 80

param environmentVariables array
param secrets array = []
param keyVaultName string
param cmsIdentityResourceId string

var location = resourceGroup().location

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyicsWorkspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
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
    name: secret.appValue
    secretRef: secret.secretName
  }
]
resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  location: location
  name: appendHash(containerAppName)
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${cmsIdentityResourceId}': {}
    }
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
      secrets: [
        for secret in secrets: {
          name: secret.secretName
          keyVaultUrl: secret.fromKeyVault ? '${keyVault.properties.vaultUri}secrets/${secret.secretName}' : null
          identity: secret.fromKeyVault ? cmsIdentityResourceId : null
          value: (!empty(secret.secretValue) && !secret.fromKeyVault) ? secret.secretValue : null
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
      initContainers: !empty(initImageName)
        ? [
            {
              name: appendHash('${containerAppName}-init')
              image: initImageName
              resources: {
                cpu: json(cpu)
                memory: memory
              }
              env: concat(environmentVariables, secrets)
            }
          ]
        : []
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output containerAppEnvironmentName string = containerAppEnvironment.name
output containerAppName string = containerApp.name
