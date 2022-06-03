
param acgName string
param location string = 'westus3'
param allowSoftDelete bool = true
param resourceExists bool = false

module azureComputeGalleryModule '../Azure-Compute-Gallery/azurecomputegallery.bicep' = if (!resourceExists) {
  name: acgName
  params: {
    acg_name: acgName
    location:location
    allowSoftDelete: allowSoftDelete
  }
}
