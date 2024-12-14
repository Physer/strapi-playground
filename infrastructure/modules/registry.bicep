import { appendHash, removeHyphens } from '../utilities.bicep'

param acrSku string = 'Basic'

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: removeHyphens(appendHash('acrstrapi'))
  location: resourceGroup().location
  sku: {
    name: acrSku
  }
}

output registryName string = containerRegistry.name
