@minLength(4)
@maxLength(63)
param logAnalyticsWorkspaceName string

@minLength(1)
@maxLength(260)
param applicationInsightsName string

param location string = resourceGroup().location

param logsRetentionInDays int = 120

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location

  properties: {
    retentionInDays: 30

    sku: {
      name: 'PerGB2018'
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'other'

  properties: {
    Application_Type: 'other'
    DisableIpMasking: false
    DisableLocalAuth: false // It's a good idea to enable this in production if you only want to allow logging from services that are part of your aad and with permissions to log.
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    RetentionInDays: logsRetentionInDays
    SamplingPercentage: 100
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
