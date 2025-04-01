@minLength(3)
@maxLength(24)
param keyVaultName string

param location string = resourceGroup().location

param enableSoftDelete bool = true

param logAnalyticsWorkspaceid string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location

  properties: {
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: enableSoftDelete

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []

      virtualNetworkRules:  []
    }

    sku: {
      family: 'A'
      name: 'standard'
    }

    tenantId: subscription().tenantId
  }
}

resource keyVaultdiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: keyVault
  name: 'keyVaultdiagnosticSettings'
  properties: {

    workspaceId: logAnalyticsWorkspaceid
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 120
        }
      }
    ]
  }
}

output keyVaultName string = keyVault.name
