@minLength(2)
@maxLength(60)
param appServiceName string

param location string = resourceGroup().location

@allowed([
  'app'
  'app,linux'
  'app,linux,container'
  'hyperV'
  'app,container,windows'
  'functionapp'
  'functionapp,linux'
])
param kind string = 'app,linux'

param serverFarmId string

param siteConfig object = {
  http20Enabled: true
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  kind: kind

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    enabled: true
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    serverFarmId: serverFarmId
    siteConfig: siteConfig
  }
}

output identityPrincipalObjectId string = appService.identity.principalId
