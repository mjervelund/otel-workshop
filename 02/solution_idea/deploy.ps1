Param(
    [Parameter(Mandatory, HelpMessage="User initials (max length 4) to use in resource names")][string]$UserInitials
)

$Timestamp = Get-Date -Format "yyMMddHHmmss"

# Microsoft Observability Workshop - msows
$SystemName = "msows${UserInitials}"
$Environment = "dev"
$Location = "swedencentral"

$ResourceGroupName = "rg-obersvabilityworkshop-dev"

az deployment group what-if `
    --name "ObservabilityWorkshop${Timestamp}" `
    --mode "Complete" `
    --resource-group $ResourceGroupName `
    --template-file ./main.bicep `
    --parameters `
        env=$Environment `
        systemName=$SystemName `
        location=$Location `
        deploymentSuffix=$Timestamp