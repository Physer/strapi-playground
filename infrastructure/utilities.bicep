@export()
func appendHash(resourceName string) string => '${resourceName}-${uniqueString(resourceGroup().id)}'

@export()
func removeHyphens(stringToReplace string) string => replace(stringToReplace, '-', '')
