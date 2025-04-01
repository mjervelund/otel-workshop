@minLength(3)
@maxLength(44)
param cosmosDbAccountName string

param location string = resourceGroup().location

@allowed([
  'GlobalDocumentDB'
  'MongoDB'
])
param databaseAccountKind string = 'MongoDB'

param capacity object = {
  totalThroughputLimit: 1000
}

param enableFreeTier bool = false

@description('If given, will attempt to store the connection string as a secret in the Key Vault')
@maxLength(24)
param keyVaultName string = ''


resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: cosmosDbAccountName
  location: location
  kind: databaseAccountKind

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    backupPolicy: {
      type: 'Periodic'

      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Local'
      }
    }

    capacity: capacity
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    enableFreeTier: enableFreeTier

    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: location
      }
    ]

    publicNetworkAccess: 'Enabled'

    virtualNetworkRules: []
  }
}
var secretName = replace('${cosmosDbAccountName}ConnectionString', '-', '')
module connectionStringSecret './keyVaultSecret.bicep' = if (!empty(keyVaultName)) {
  name: secretName

  params: {
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: databaseAccount.listConnectionStrings().connectionStrings[0].connectionString
  }
}

output name string = databaseAccount.name
output connectionStringSecretName string = secretName
