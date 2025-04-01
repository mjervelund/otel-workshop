@minLength(1)
@maxLength(40)
param appServicePlanName string

param location string = resourceGroup().location
param skuName string = 'F1' // See https://learn.microsoft.com/azure/app-service/overview-hosting-plans
param capacity int = 1

param logAnalyticsWorkspaceid string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'

  properties: {
    reserved: true
  }

  sku: {
    name: skuName
    capacity: capacity
  }
}

resource appServicePlanDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: appServicePlan
  name: 'openAiNamediagnosticSettings'
  properties: {
    workspaceId: logAnalyticsWorkspaceid
    logs: []
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 120
          enabled: true
        }
      }
    ]
  }
}

output appServicePlanId string = appServicePlan.id
