@allowed([
  'nght' // Nightly build
  'dev'
  'test'
  'prod'
])
param env string = 'dev'

@minLength(2)
@maxLength(12)
@description('Used in all resource names unless overridden - as an example: Cosmos DB account will have the name cosmos-{systemName}-{env} e.g., cosmos-system-dev')
param systemName string

param location string = resourceGroup().location

param deploymentSuffix string = '' // Recommended suffix is a timestamp in yyMMddHHmm format or build ID

module resourceNames 'config/resourceNames.bicep' = {
  name: 'resourceNames'

  params: {
    env: env
    systemName: systemName
  }
}

module azureMonitor 'templates/azureMonitor.bicep' = {
  name: 'azureMonitor${deploymentSuffix}'

  params: {
    logAnalyticsWorkspaceName: resourceNames.outputs.logAnalyticsWorkspaceName
    applicationInsightsName: resourceNames.outputs.applicationInsightsName
    location: location
  }
}
