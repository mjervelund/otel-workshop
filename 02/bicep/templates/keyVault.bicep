@minLength(3)
@maxLength(24)
param keyVaultName string

param location string = resourceGroup().location

param enableSoftDelete bool = true

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



output keyVaultName string = keyVault.name
