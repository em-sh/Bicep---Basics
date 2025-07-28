@description('The location where the resources will be deployed.')
param location string = 'westus3'

@description('The name of the App Service app.')
param appServiceAppName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('The name of the App Service plan.')
param appServicePlanName string = 'toy-launch-plan'

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'F1'


module app 'modules/app.bicep' = {
  name: 'tou-launch-app'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
  }
}

@description('Indicates whether to deploy a CDN profile and endpoint.')
param deployCdn bool = true

module cdn 'modules/cdn.bicep' = if (deployCdn) {
  name: 'toy-launch-cdn'
  params: {
    originHostName: app.outputs.appServiceAppHostName
    httpsOnly: true
  }
}

@description('The host name of the deployed website.')
output websiteHostName string = deployCdn ? cdn.outputs.endpointHostName : app.outputs.appServiceAppHostName
