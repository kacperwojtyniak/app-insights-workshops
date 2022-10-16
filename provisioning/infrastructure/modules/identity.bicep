@description('Location of resources (e.g., WestEurope, WestUS)')
param location string

@description('Base for constructing resource names. Should be defined in main.bicep and passed into each module.')
param resource_name_base string

var managedIdentityName = 'id-${resource_name_base}'

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName  
  location: location
}

@description('User assigned managed identity details. Used to assign the identity to App Service, assign permissions, etc.')
output identity object = {  
  id: managed_identity.id
  clientId: managed_identity.properties.clientId
  principalId: managed_identity.properties.principalId
}
