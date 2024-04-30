terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.101.0"
    }
  }
}

provider "azurerm" {
    features {
      
    }
}


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "Resources in this resource group can't be deleted."
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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