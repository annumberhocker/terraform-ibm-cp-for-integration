variable "cluster_id" {
  description = "ROKS cluster id. Use the ROKS terraform module or other way to create it"
}

# variable "region" {
#   description = "Region of the cluster"
# }

variable "resource_group_name" {
  description = "Resource group that the cluster is created in"
}

variable "on_vpc" {
  default     = false
  type        = bool
  description = "If set to true, lets the module know cluster is using VPC Gen2"
}

variable "portworx_is_ready" {
  type = any
  default = null
}

variable "openshift_version" {
  default     = "4.6"
  type        = string
  description = "Openshift version installed in the cluster"
}

variable "entitled_registry_key" {
  type        = string
  description = "Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary"
}

variable "entitled_registry_user_email" {
  type        = string
  description = "Docker email address"
}

locals {
  kube_config_path = "./.kube/config"
  namespace = "cp4i"
}