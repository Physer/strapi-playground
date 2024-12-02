@export()
func appendHash(resourceName string) string => '${resourceName}-${uniqueString(resourceGroup().id)}'
