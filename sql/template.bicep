param administratorLogin string = ''

@secure()
param administratorLoginPassword string = ''
param administrators object = {
}
param serverName string
param serverLocation string
param elasticPoolName string
param skuName string
param tier string
param poolLimit string
param poolSize int
param perDatabasePerformanceMin string
param perDatabasePerformanceMax string
param zoneRedundant bool = false
param readscaleReplicas int
param licenseType string = ''
param minCapacity string
param allowAzureIps bool = true
param serverTags object = {
}
param elasticPoolTags object = {
}
param maintenanceConfigurationId string = ''

resource server 'Microsoft.Sql/servers@2020-11-01-preview' = {
  tags: serverTags
  location: serverLocation
  name: serverName
  properties: {
    version: '12.0'
    administrators: administrators
  }
}

resource serverName_elasticPool 'Microsoft.Sql/servers/elasticpools@2021-08-01-preview' = {
  parent: server
  tags: elasticPoolTags
  location: serverLocation
  name: '${elasticPoolName}'
  sku: {
    name: skuName
    tier: tier
    capacity: poolLimit
  }
  properties: {
    perDatabaseSettings: {
      minCapacity: perDatabasePerformanceMin
      maxCapacity: perDatabasePerformanceMax
    }
    highAvailabilityReplicaCount: readscaleReplicas
    maxSizeBytes: poolSize
    zoneRedundant: zoneRedundant
    minCapacity: minCapacity
    licenseType: licenseType
    maintenanceConfigurationId: maintenanceConfigurationId
  }
}

resource serverName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallrules@2014-04-01-preview' = if (allowAzureIps) {
  parent: server
  location: serverLocation
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}