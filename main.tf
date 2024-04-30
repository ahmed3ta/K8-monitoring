terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.101.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "terraform-backend"
      storage_account_name = "$(tfbackend_sa)"
      container_name       = "$(tfbackend_container)"
      key                  = "$(tfbackend_key)"
  }
}

provider "azurerm" {
    features {
      
    }
    skip_provider_registration = true
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.node_pool_vm_size
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "k8s_np" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s_cluster.id
  vm_size               = var.node_pool_vm_size
  node_count            = 1

  tags = var.tags
}
