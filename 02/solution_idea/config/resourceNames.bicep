@allowed([
  'nght' // Nightly build
  'dev'
  'test'
  'prod'
])
param env string = 'dev'

@minLength(2)
@maxLength(12)
@description('Used in all resource names unless overriden - as an example: Cosmos DB account will have the name cosmos-{systemName}-{env} e.g., cosmos-overlord-dev')
param systemName string


@minLength(3)
@maxLength(24)
output keyVaultName string = 'kv-${systemName}-${env}'

@minLength(4)
@maxLength(63)
output logAnalyticsWorkspaceName string = 'log-${systemName}-${env}'

@minLength(3)
@maxLength(63)
output applicationInsightsName string = 'appi-${systemName}-${env}'

@minLength(3)
@maxLength(24)
output azureMonitorStorageAccountName string = 'stappi${systemName}${env}'

output applicationInsightsConnectionStringSecretName string = 'applicationInsightsConnectionString'

@minLength(1)
@maxLength(40)
output appServicePlanName string = 'asp-${systemName}-${env}'

@minLength(2)
@maxLength(60)
output apiAppServiceName string = 'app-${systemName}-${env}'
