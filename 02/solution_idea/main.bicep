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
  }
}

module keyVault './templates/keyVault.bicep' = {
  name: 'keyVault${deploymentSuffix}'

  params: {
    keyVaultName: resourceNames.outputs.keyVaultName
    logAnalyticsWorkspaceid: azureMonitor.outputs.logAnalyticsWorkspaceId
    location: location
  }
}

module applicationInsightsConnectionStringSecret './templates/keyVaultSecret.bicep' = {
  name: 'applicationInsightsConnectionStringSecret'

  params: {
    keyVaultName: keyVault.outputs.keyVaultName
    secretName: resourceNames.outputs.applicationInsightsConnectionStringSecretName
    secretValue: azureMonitor.outputs.applicationInsightsConnectionString
  }
}



module appServicePlan 'templates/appServicePlan.bicep' = {
  name: 'appServicePlan${deploymentSuffix}'

  params: {
    appServicePlanName: resourceNames.outputs.appServicePlanName
    location: location
    skuName: 'F1'
    logAnalyticsWorkspaceid: azureMonitor.outputs.logAnalyticsWorkspaceId
    capacity: 1
  }
}

module AppService 'templates/appService.bicep' = {
  name: 'apiAppService${deploymentSuffix}'

  params: {
    appServiceName: resourceNames.outputs.apiAppServiceName
    location: location
    serverFarmId: appServicePlan.outputs.appServicePlanId
    logAnalyticsWorkspaceid: azureMonitor.outputs.logAnalyticsWorkspaceId
  }
}

module keyVaultRoleAssignmentsForAppService 'templates/keyVaultRoleAssignments.bicep' = {
  name: 'keyVaultRoleAssignmentsForApi${deploymentSuffix}'

  params: {
    keyVaultName: keyVault.outputs.keyVaultName
    principalObjectId: AppService.outputs.identityPrincipalObjectId
    principalType: 'ServicePrincipal'

    roles: [
      '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
    ]
  }
}

module azureOpenAI 'templates/azureOpenAI.bicep' = {
  name: 'azureOpenAI${deploymentSuffix}'

  params: {
    openAiName: 'oai-${systemName}-${env}'
    location: location
    logAnalyticsWorkspaceid: azureMonitor.outputs.logAnalyticsWorkspaceId
  }
}

