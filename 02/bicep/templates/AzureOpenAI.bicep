@description('Name of the OpenAI service instance')
param openAiName string

@description('The Azure location where the OpenAI service will be deployed')
param location string = resourceGroup().location

@description('The pricing tier of the OpenAI service')
param skuName string = 'S0'

@description('Lowers the capacity for OpenAI models in case the subscription has low quota')
param lowCapacity bool = false

var gptCapacity = lowCapacity ? 50 : 100
var embeddingCapacity = lowCapacity ? 50 : 150

resource azureOpenAI 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: openAiName
  location: location
  sku: {
    name: skuName
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {}
    customSubDomainName: openAiName
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource azureOpenAI_gpt_4o 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: azureOpenAI
  name: 'gpt-4o'
  sku: {
    name: 'GlobalStandard'
    capacity: gptCapacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-11-20'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: gptCapacity
    raiPolicyName: 'Microsoft.DefaultV2'
  }
}

resource azureOpenAI_gpt_35_turbo 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: azureOpenAI
  name: 'gpt-35-turbo'
  sku: {
    name: 'Standard'
    capacity: 50
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-35-turbo'
      version: '0125'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 50
    raiPolicyName: 'Microsoft.DefaultV2'
  }
  dependsOn: [
    azureOpenAI_gpt_4o
  ]
}


resource azureOpenAI_embedding 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: azureOpenAI
  name: 'embedding'
  sku: {
    name: 'GlobalStandard'
    capacity: embeddingCapacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-3-large'
      version: '1'
    }
    versionUpgradeOption: 'NoAutoUpgrade'
    currentCapacity: embeddingCapacity
    raiPolicyName: 'Microsoft.DefaultV2'
  }
  dependsOn: [
    azureOpenAI_gpt_4o
    azureOpenAI_gpt_35_turbo
  ]
}
