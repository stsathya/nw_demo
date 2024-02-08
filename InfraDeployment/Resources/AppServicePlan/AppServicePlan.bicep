param location string
param skuName string
param skuCapacity int
param appName string

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appName
  location: location
  sku: {
    name: skuName
    tier: 'Standard'
    capacity: skuCapacity
  }
  kind: 'app'
}
