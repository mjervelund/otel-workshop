@allowed([
  'nght' // Nightly build
  'dev'
  'test'
  'prod'
])
param env string = 'dev'

param location string = ''

param instance string = ''

@minLength(2)
@maxLength(12)
@description('Used in all resource names - as an example: Mongo Cosmos DB account will have the name cosmon-{systemName}-{env} e.g., cosmon-system-dev')
param systemName string

@allowed([
  'srch' // Microsoft.Search/searchServices
  'ais' // Microsoft.CognitiveServices/accounts (kind: AIServices)
  'hub' // Microsoft.MachineLearningServices/workspaces (kind: Hub)
  'proj' // Microsoft.MachineLearningServices/workspaces (kind: Project)
  'avi' // Microsoft.VideoIndexer/accounts
  'mlw' // Microsoft.MachineLearningServices/workspaces
  'oai' // Microsoft.CognitiveServices/accounts (kind: OpenAI)
  'bot' // Microsoft.BotService/botServices (kind: azurebot)
  'cv' // Microsoft.CognitiveServices/accounts (kind: ComputerVision)
  'cm' // Microsoft.CognitiveServices/accounts (kind: ContentModerator)
  'cs' // Microsoft.CognitiveServices/accounts (kind: ContentSafety)
  'cstv' // Microsoft.CognitiveServices/accounts (kind: CustomVision.Prediction)
  'cstvt' // Microsoft.CognitiveServices/accounts (kind: CustomVision.Training)
  'di' // Microsoft.CognitiveServices/accounts (kind: FormRecognizer)
  'face' // Microsoft.CognitiveServices/accounts (kind: Face)
  'hi' // Microsoft.CognitiveServices/accounts (kind: HealthInsights)
  'ir' // Microsoft.CognitiveServices/accounts (kind: ImmersiveReader)
  'lang' // Microsoft.CognitiveServices/accounts (kind: TextAnalytics)
  'spch' // Microsoft.CognitiveServices/accounts (kind: SpeechServices)
  'trsl' // Microsoft.CognitiveServices/accounts (kind: TextTranslation)
  'as' // Microsoft.AnalysisServices/servers
  'dbw' // Microsoft.Databricks/workspaces
  'dec' // Microsoft.Kusto/clusters
  'dedb' // Microsoft.Kusto/clusters/databases
  'adf' // Microsoft.DataFactory/factories
  'dt' // Microsoft.DigitalTwins/digitalTwinsInstances
  'asa' // Microsoft.StreamAnalytics/cluster
  'synplh' // Microsoft.Synapse/privateLinkHubs
  'syndp' // Microsoft.Synapse/workspaces/sqlPools
  'synsp' // Microsoft.Synapse/workspaces/bigDataPools
  'synw' // Microsoft.Synapse/workspaces
  'dls' // Microsoft.DataLakeStore/accounts
  'dla' // Microsoft.DataLakeAnalytics/accounts
  'evhns' // Microsoft.EventHub/namespaces
  'evh' // Microsoft.EventHub/namespaces/eventHubs
  'evgd' // Microsoft.EventGrid/domains
  'evgs' // Microsoft.EventGrid/eventSubscriptions
  'evgt' // Microsoft.EventGrid/domains/topics
  'egst' // Microsoft.EventGrid/systemTopics
  'hadoop' // Microsoft.HDInsight/clusters
  'hbase' // Microsoft.HDInsight/clusters
  'kafka' // Microsoft.HDInsight/clusters
  'spark' // Microsoft.HDInsight/clusters
  'storm' // Microsoft.HDInsight/clusters
  'mls' // Microsoft.HDInsight/clusters
  'iot' // Microsoft.Devices/IotHubs
  'provs' // Microsoft.Devices/provisioningServices
  'pcert' // Microsoft.Devices/provisioningServices/certificates
  'pbi' // Microsoft.PowerBIDedicated/capacities
  'tsi' // Microsoft.TimeSeriesInsights/environments
  'ase' // Microsoft.Web/hostingEnvironments
  'asp' // Microsoft.Web/serverFarms
  'lt' // Microsoft.LoadTestService/loadTests
  'avail' // Microsoft.Compute/availabilitySets
  'arcs' // Microsoft.HybridCompute/machines
  'arck' // Microsoft.Kubernetes/connectedClusters
  'pls' // Microsoft.HybridCompute/privateLinkScopes
  'ba' // Microsoft.Batch/batchAccounts
  'cld' // Microsoft.Compute/cloudServices
  'acs' // Microsoft.Communication/communicationServices
  'des' // Microsoft.Compute/diskEncryptionSets
  'func' // Microsoft.Web/sites
  'gal' // Microsoft.Compute/galleries
  'host' // Microsoft.Web/hostingEnvironments
  'it' // Microsoft.VirtualMachineImages/imageTemplates
  'osdisk' // Microsoft.Compute/disks
  'disk' // Microsoft.Compute/disks
  'ntf' // Microsoft.NotificationHubs/namespaces/notificationHubs
  'ntfns' // Microsoft.NotificationHubs/namespaces
  'ppg' // Microsoft.Compute/proximityPlacementGroups
  'rpc' // Microsoft.Compute/restorePointCollections
  'snap' // Microsoft.Compute/snapshots
  'stapp' // Microsoft.Web/staticSites
  'vm' // Microsoft.Compute/virtualMachines
  'vmss' // Microsoft.Compute/virtualMachineScaleSets
  'mc' // Microsoft.Maintenance/maintenanceConfigurations
  'stvm' // Microsoft.Storage/storageAccounts
  'app' // Microsoft.Web/sites
  'aks' // Microsoft.ContainerService/managedClusters
  'npsystem' // Microsoft.ContainerService/managedClusters/agentPools (mode: System)
  'np' // Microsoft.ContainerService/managedClusters/agentPools (mode: User)
  'ca' // Microsoft.App/containerApps
  'cae' // Microsoft.App/managedEnvironments
  'cr' // Microsoft.ContainerRegistry/registries
  'ci' // Microsoft.ContainerInstance/containerGroups
  'sf' // Microsoft.ServiceFabric/clusters
  'sfmc' // Microsoft.ServiceFabric/managedClusters
  'cosmos' // Microsoft.DocumentDB/databaseAccounts/sqlDatabases
  'coscas' // Microsoft.DocumentDB/databaseAccounts
  'cosmon' // Microsoft.DocumentDB/databaseAccounts
  'cosno' // Microsoft.DocumentDb/databaseAccounts
  'costab' // Microsoft.DocumentDb/databaseAccounts
  'cosgrm' // Microsoft.DocumentDb/databaseAccounts
  'cospos' // Microsoft.DBforPostgreSQL/serverGroupsv2
  'redis' // Microsoft.Cache/Redis
  'sql' // Microsoft.Sql/servers
  'sqldb' // Microsoft.Sql/servers/databases
  'sqlja' // Microsoft.Sql/servers/jobAgents
  'sqlep' // Microsoft.Sql/servers/elasticpool
  'maria' // Microsoft.DBforMariaDB/servers
  'mariadb' // Microsoft.DBforMariaDB/servers/databases
  'mysql' // Microsoft.DBforMySQL/servers
  'psql' // Microsoft.DBforPostgreSQL/servers
  'sqlstrdb' // Microsoft.Sql/servers/databases
  'sqlmi' // Microsoft.Sql/managedInstances
  'appcs' // Microsoft.AppConfiguration/configurationStores
  'map' // Microsoft.Maps/accounts
  'sigr' // Microsoft.SignalRService/SignalR
  'wps' // Microsoft.SignalRService/webPubSub
  'amg' // Microsoft.Dashboard/grafana
  'apim' // Microsoft.ApiManagement/service
  'ia' // Microsoft.Logic/integrationAccounts
  'logic' // Microsoft.Logic/workflows
  'sbns' // Microsoft.ServiceBus/namespaces
  'sbq' // Microsoft.ServiceBus/namespaces/queues
  'sbt' // Microsoft.ServiceBus/namespaces/topics
  'sbts' // Microsoft.ServiceBus/namespaces/topics/subscriptions
  'aa' // Microsoft.Automation/automationAccounts
  'appi' // Microsoft.Insights/components
  'ag' // Microsoft.Insights/actionGroups
  'dcr' // Microsoft.Insights/dataCollectionRules
  'apr' // Microsoft.AlertsManagement/actionRules
  'bp' // Microsoft.Blueprint/blueprints
  'bpa' // Microsoft.Blueprint/blueprints/artifacts
  'dce' // Microsoft.Insights/dataCollectionEndpoints
  'log' // Microsoft.OperationalInsights/workspaces
  'pack' // Microsoft.OperationalInsights/querypacks
  'mg' // Microsoft.Management/managementGroups
  'pview' // Microsoft.Purview/accounts
  'rg' // Microsoft.Resources/resourceGroups
  'ts' // Microsoft.Resources/templateSpecs
  'migr' // Microsoft.Migrate/assessmentProjects
  'dms' // Microsoft.DataMigration/services
  'rsv' // Microsoft.RecoveryServices/vaults
  'agw' // Microsoft.Network/applicationGateways
  'asg' // Microsoft.Network/applicationSecurityGroups
  'cdnp' // Microsoft.Cdn/profiles
  'cdne' // Microsoft.Cdn/profiles/endpoints
  'con' // Microsoft.Network/connections
  'dnsfrs' // Microsoft.Network/dnsForwardingRulesets
  'dnspr' // Microsoft.Network/dnsResolvers
  'in' // Microsoft.Network/dnsResolvers/inboundEndpoints
  'out' // Microsoft.Network/dnsResolvers/outboundEndpoints
  'afw' // Microsoft.Network/azureFirewalls
  'afwp' // Microsoft.Network/firewallPolicies
  'erc' // Microsoft.Network/expressRouteCircuits
  'erd' // Microsoft.Network/expressRoutePorts
  'ergw' // Microsoft.Network/virtualNetworkGateways
  'afd' // Microsoft.Cdn/profiles
  'fde' // Microsoft.Cdn/profiles/afdEndpoints
  'fdfp' // Microsoft.Network/frontdoorWebApplicationFirewallPolicies
  'afd' // Microsoft.Network/frontDoors
  'ipg' // Microsoft.Network/ipGroups
  'lbi' // Microsoft.Network/loadBalancers
  'lbe' // Microsoft.Network/loadBalancers
  'rule' // Microsoft.Network/loadBalancers/inboundNatRules
  'lgw' // Microsoft.Network/localNetworkGateways
  'ng' // Microsoft.Network/natGateways
  'nic' // Microsoft.Network/networkInterfaces
  'nsg' // Microsoft.Network/networkSecurityGroups
  'nsgsr' // Microsoft.Network/networkSecurityGroups/securityRules
  'nw' // Microsoft.Network/networkWatchers
  'pl' // Microsoft.Network/privateLinkServices
  'pep' // Microsoft.Network/privateEndpoints
  'pip' // Microsoft.Network/publicIPAddresses
  'ippre' // Microsoft.Network/publicIPPrefixes
  'rf' // Microsoft.Network/routeFilters
  'rtserv' // Microsoft.Network/virtualHubs
  'rt' // Microsoft.Network/routeTables
  'se' // Microsoft.serviceEndPointPolicies
  'traf' // Microsoft.Network/trafficManagerProfiles
  'udr' // Microsoft.Network/routeTables/routes
  'vnet' // Microsoft.Network/virtualNetworks
  'vgw' // Microsoft.Network/virtualNetworkGateways
  'vnm' // Microsoft.Network/networkManagers
  'peer' // Microsoft.Network/virtualNetworks/virtualNetworkPeerings
  'snet' // Microsoft.Network/virtualNetworks/subnets
  'vwan' // Microsoft.Network/virtualWans
  'vhub' // Microsoft.Network/virtualHubs
  'bas' // Microsoft.Network/bastionHosts
  'kv' // Microsoft.KeyVault/vaults
  'kvmhsm' // Microsoft.KeyVault/managedHSMs
  'id' // Microsoft.ManagedIdentity/userAssignedIdentities
  'sshkey' // Microsoft.Compute/sshPublicKeys
  'vpng' // Microsoft.Network/vpnGateways
  'vcn' // Microsoft.Network/vpnGateways/vpnConnections
  'vst' // Microsoft.Network/vpnGateways/vpnSites
  'waf' // Microsoft.Network/firewallPolicies
  'wafrg' // Microsoft.Network/firewallPolicies/ruleGroups
  'ssimp' // Microsoft.StorSimple/managers
  'bvault' // Microsoft.DataProtection/backupVaults
  'bkpol' // Microsoft.DataProtection/backupVaults/backupPolicies
  'share' // Microsoft.Storage/storageAccounts/fileServices/shares
  'st' // Microsoft.Storage/storageAccounts
  'sss' // Microsoft.StorageSync/storageSyncServices
  'vdpool' // Microsoft.DesktopVirtualization/hostPools
  'vdag' // Microsoft.DesktopVirtualization/applicationGroups
  'vdws' // Microsoft.DesktopVirtualization/workspaces
  'vdscaling' // Microsoft.DesktopVirtualization/scalingPlans
  // '<descriptive>' // Microsoft.Authorization/policyDefinitions
  // '<DNS domain name>' // Microsoft.Network/dnsZones
  // '<DNS domain name>' // Microsoft.Network/privateDnsZones
])
param resourceAbbreviation string

param component string = ''

var withoutdelimiter = [
  'gal'
  'cr'
  'st'
]

var delimiter = contains(withoutdelimiter, resourceAbbreviation) ? '' :  '-'

var resourceNameList = [
  resourceAbbreviation
  systemName
  component
  env
  location
  instance
]

// <resource name abbreviation>-<system name>-<component>-<environment>-<location>-<instance>`

output resourceName string = join(filter(resourceNameList,i => i != ''), delimiter)
