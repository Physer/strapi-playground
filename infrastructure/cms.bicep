import { appendHash } from './utilities.bicep'

targetScope = 'subscription'

param environment string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'rg-strapi-playground-${environment}'
  location: deployment().location
}

module containerRegistry 'modules/registry.bicep' = {
  scope: resourceGroup
  name: 'deployContainerRegistry'
}

module logAnalyticsWorkspace 'modules/logAnalytics.bicep' = {
  scope: resourceGroup
  name: 'deployLogAnalytics'
}

module cmsContainerApp 'modules/containerApp.bicep' = {
  scope: resourceGroup
  name: 'deployCmsContainer'
  params: {
    containerAppEnvironmentName: 'cae-cms'
    containerAppName: 'ca-cms'
    imageName: 'nginx:latest'
    logAnalyicsWorkspaceName: logAnalyticsWorkspace.outputs.resourceName
  }
}
