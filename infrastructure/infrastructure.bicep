import { appendHash, removeHyphens } from './utilities.bicep'

param acrSku string = 'Basic'

var location = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: removeHyphens(appendHash('acrstrapi'))
  location: location
  sku: {
    name: acrSku
  }
}
