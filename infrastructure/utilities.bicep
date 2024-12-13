@export()
func appendHash(resourceName string) string => '${resourceName}-${uniqueString(resourceGroup().id)}'

@export()
func removeHyphens(stringToReplace string) string => replace(stringToReplace, '-', '')

@export()
func replaceUnderscoresWithDashes(secret string) string => replace(secret, '_', '-')
