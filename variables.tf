variable "resource_group_name" {
  type = string
  default = "k8s-with-monitoring"
}

variable "location" {
  type = string
  default = "West Europe"
}

variable "kubernetes_cluster_name" {
  type = string
  default = "kubernetes-cluster"
}

variable "node_pool_vm_size" {
  type = string
  default = "Standard_D2_v2"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
  }
}