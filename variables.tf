variable "resource_group_name" {
  type = string
  default = "#{resource_group_name}#"
}

variable "location" {
  type = string
  default = "#{location}#"
}

variable "kubernetes_cluster_name" {
  type = string
  default = "#{kubernetes_cluster_name}#"
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