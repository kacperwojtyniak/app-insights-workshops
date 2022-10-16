@description('Location of resources (e.g., WestEurope, WestUS)')
param location string

@description('Managed identity that should be attached to the App Service. Included in the output of `user-assigned-identity.bicep`.')
param user_managed_identity object

@description('The base for constructing resource names. Should be defined in main.bicep and passed into each module.')
param resource_name_base string

var app_service_plan_name = 'plan-${resource_name_base}'
var app_service_name = 'app-${resource_name_base}'

resource service_plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  location: location
  name: app_service_plan_name
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource app_service 'Microsoft.Web/sites@2021-02-01' = {
  location: location
  name: app_service_name
  properties: {
    serverFarmId: service_plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      alwaysOn: true
      http20Enabled: true
      appSettings: [
        {
          name: 'ASPNETCORE_HTTPS_PORT'
          value: '443'
        }
        {
          name: 'MANAGED_IDENTITY_ID'
          value: user_managed_identity.clientId
        }
      ]   
    }
    clientAffinityEnabled: false
    httpsOnly: true
    keyVaultReferenceIdentity: user_managed_identity.id
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${user_managed_identity.id}': {}
    }
  }
}

output url string = '${app_service.name}.azurewebsites.net'
