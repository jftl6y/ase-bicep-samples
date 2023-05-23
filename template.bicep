@description('Region where the ASE will be deployed')
param ase_location string
@description('name of the appservice app')
param app_name string

@description('name of the appservice environment')
param ase_name string

@description('The name of the Vnet where the ASE will be deployed')
param ase_vnet_name string

@description('The name of the subnet where the ASE will be deployed')
param ase_subnet_name string

var app_service_plan_name = 'concat{parameters(\'app_name\'), \'-asp\'}'

resource ase_resource 'Microsoft.Web/hostingEnvironments@2022-09-01' = {
  name: ase_name
  location: ase_location
  kind: 'ASEV3'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetwork/subnets', ase_vnet_name, ase_subnet_name)
    }
    internalLoadBalancingMode: 'Web, Publishing'
    multiSize: 'Standard_D2d_v4'
    ipsslAddressCount: 0
    dnsSuffix: '${ase_name}.appserviceenvironment.us'
    frontEndScaleFactor: 15
    upgradePreference: 'None'
    dedicatedHostCount: 0
    zoneRedundant: false
    networkingConfiguration: {}
  }
}

resource app_service_plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: app_service_plan_name
  location: ase_location
  sku: {
    name: 'I1v2'
    tier: 'IsolatedV2'
    size: 'I1v2'
    family: 'Iv2'
    capacity: 1
  }
  kind: 'app'
  properties: {
    hostingEnvironmentProfile: {
      id: ase_resource.id
    }
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource app_name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: app_name
  location: ase_location
  kind: 'app'
  properties: {
    enabled: true
    serverFarmId: ase_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: true
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    hostingEnvironmentProfile: {
      id: ase_resource.id
    }
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
  }
}
