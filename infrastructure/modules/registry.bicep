import { appendHash, removeHyphens } from '../utilities.bicep'

param acrSku string = 'Basic'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: removeHyphens(appendHash('acrstrapi'))
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
}

output containerRegistryName string = containerRegistry.name
