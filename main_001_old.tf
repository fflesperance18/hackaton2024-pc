provider "azurerm" {
  features {}
}

# Create EverBridgeCEM resource group
resource "azurerm_resource_group" "EverBridgeCEM" {
  name     = "EverBridgeCEM-resources"
  location = "East US"
}

# Create EverBridgeCEM storage acct
resource "azurerm_storage_accountg" "EverBridgeCEM_str_acct" {
  name     = "EverBridgeCEM_str_acct"
  resource_group_name=azurerm_resource_group.EverBridgeCEM.name 
  location=azurerm_resource_group.EverBridgeCEM.location
  account_tier="Standard"
  account_replication_type="LRS"
  
  tags={
    environment = "Test"
  }
}

# Create EverBridgeCEM resource group
resource "azurerm_resource_group" "EverBridgeCEM" {
  name     = "EverBridgeCEM-resources"
  location = "East US"
}

# Create EverBridgeCEM storage acct
resource "azurerm_storage_accountg" "EverBridgeCEM_str_acct" {
  name     = "EverBridgeCEM_str_acct"
  resource_group_name=azurerm_resource_group.EverBridgeCEM.name 
  location=azurerm_resource_group.EverBridgeCEM.location
  account_tier="Standard"
  account_replication_type="LRS"
  
  tags={
    environment = "Test"
  }
}
#remove bad files
#remove bad files


# Create AKS cluster
resource "azurerm_kubernetes_cluster" "EverBridgeCEM" {
  name                = "EverBridgeCEM-aks-cluster"
  location            = azurerm_resource_group.EverBridgeCEM.location
  resource_group_name = azurerm_resource_group.EverBridgeCEM.name
  dns_prefix          = "EverBridgeCEM-aks-cluster-dns"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "TEST"
  }
}

# Create Everbridge CEM resources
# (Replace with actual Everbridge CEM resource definitions)
#resource "everbridge_cem_resource" "EverBridgeCEM" {
#  name     = "EverBridgeCEM-resource"
#  location = "East US"
#  resource_group_name = azurerm_resource_group.EverBridgeCEM.name
  # Add other Everbridge CEM resource configuration here
#}

# Create Azure Data Factory pipeline
resource "azurerm_data_factory" "WrkDayEverBridgeCEM" {
  name                = "WrkDayEverBridgeCEM-adf"
  resource_group_name = azurerm_resource_group.EverBridgeCEM.name
  location            = azurerm_resource_group.EverBridgeCEM.location
}

#resource "azurerm_data_factory_pipeline" "EverBridgeCEM" {
#  name                = "EverBridgeCEM-pipeline"
# resource_group_name = azurerm_resource_group.EverBridgeCEM.name
#factory_name        = azurerm_data_factory.EverBridgeCEM.name
# description         = "EverBridgeCEM ADF pipeline"

  # Add pipeline activities here
#}

# Add pipeline activities, datasets, and linked services as needed

# Output AKS cluster details
output "aks_cluster_details" {
  value = azurerm_kubernetes_cluster.EverBridgeCEM
  sensitive = true
}


resource "azurerm_container_registry" "PC_ACR" {
  name                     = "PC_ACR_001"
  resource_group_name = azurerm_resource_group.EverBridgeCEM.name
  location            = azurerm_resource_group.EverBridgeCEM.location
  sku                      = "Standard"  # or "Basic" or "Premium"
  admin_enabled            = true        # Enable admin user for ACR
}

output "acr_login_server" {
  value = azurerm_container_registry.PC_ACR_001.login_server
}

resource "kubernetes_service" "website_service" {
  metadata {
    name = "website-service"
  }

  spec {
    selector = {
      app = "website"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

