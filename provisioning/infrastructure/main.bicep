@description('Location of resources (e.g., WestEurope, WestUS)')
param location string = 'westeurope'

@description('Enter your name or nickname')
param your_name string

param deployment_name string = utcNow()

var resource_name_base = 'appiworkshops-${your_name}'

module managed_identity_module 'modules/identity.bicep' = {
  name: 'identity_${deployment_name}'
  params: {
    location: location
    resource_name_base: resource_name_base
  }
}

module app_service_module 'modules/app-service.bicep' = {
  name: 'app_service_${deployment_name}'
  params: {
    location: location
    resource_name_base: resource_name_base
    user_managed_identity: managed_identity_module.outputs.identity
  }
}

output app_url string = app_service_module.outputs.url
