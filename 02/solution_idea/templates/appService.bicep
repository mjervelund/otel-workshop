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

param logAnalyticsWorkspaceid string

param siteConfig object = {
  http20Enabled: true
}

var appServiceLogs = kind != 'functionapp,linux'
  ? [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
    ]
  : [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]

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

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'ds-${appServiceName}'
  scope: appService

  properties: {
    logs: appServiceLogs

    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]

    workspaceId: logAnalyticsWorkspaceid
  }
}

output identityPrincipalObjectId string = appService.identity.principalId
