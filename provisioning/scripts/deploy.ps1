$yourName = 'kacper'
$subscriptionNameOrId = 'f529a133-69e9-4db6-bad2-03901d35b722'

az login

az account set -s $subscriptionNameOrId

$rgName = "rg-${yourName}"

$exists = az group exists -n $rgname

if($exists -eq 'false')
{
    az group create -n $rgName -l 'westeurope'
}

$output = az deployment group create -g $rgName -f '..\infrastructure\main.bicep' -p your_name=$yourName --query properties.outputs | ConvertFrom-Json

Write-Host $output.app_url.value -ForegroundColor Green

dotnet publish ../../src/AppiWorkshops/AppiWorkshops.csproj -c Release

# Publish using VS Code


