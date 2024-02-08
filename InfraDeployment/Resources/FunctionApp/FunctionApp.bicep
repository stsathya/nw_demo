param appName string
param location string
param sqlServer string
param sqlServerDomain string
param adminUsername string
@secure()
param adminPassword string

//var uniqueFunctionAppName = '${appName}${uniqueString(resourceGroup().id)}'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appName}-insight'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: appName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appName)
    publicNetworkAccess: 'Enabled'
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'SqlConnectionString'
          value: 'Server=tcp:${sqlServer}${sqlServerDomain};User ID=${adminUsername};Password=${adminPassword};Encrypt=True;Connection Timeout=30;'
        }
      ]
    }
  }
}
