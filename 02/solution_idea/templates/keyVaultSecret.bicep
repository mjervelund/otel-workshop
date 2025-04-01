@minLength(3)
@maxLength(24)
param keyVaultName string

param secretName string

@secure()
param secretValue string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: keyVault
  name: secretName

  properties: {
    value: secretValue
  }
}
