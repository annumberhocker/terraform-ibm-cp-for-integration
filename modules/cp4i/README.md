# Module cp4i

This module is used to install Cloud Pak for Integration on an existing OpenShift cluster

## Example Usage

```hcl
provider "ibm" {
}

data "ibm_resource_group" "group" {
  name = var.resource_group_name
}

// Make directory to store cluster config
resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "mkdir -p ${local.kube_config_path}"
  }
}

// Pull down the cluster configuration
data "ibm_container_cluster_config" "cluster_config" {
  depends_on = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = local.kube_config_path
}

// Cloud Pak for Integration module
module "cp4i" {
  source = "../../modules/cp4i"
  enable = true

  // ROKS cluster parameters:
  cluster_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
  storageclass        = "ibmc-file-gold-gid"

  // Entitled Registry parameters:
  entitled_registry_key        = "<entitlement_key>"
  entitled_registry_user_email = "<entitlement_email>"

  namespace           = "cp4i"
}
```

### Inputs

| Name                               | Description  | Default                     | Required |
| ---------------------------------- | ----- | --------------------------- | -------- |
| `cluster_id`                       | ID of the cluster to install cloud pak on. Cluster needs to be at least 4 nodes of size 16x64.|                             | Yes       |
| `resource_group`                   | Resource Group in your account to host the cluster. List all available resource groups with: `ibmcloud resource groups`     | `cloud-pak-sandbox`         | Yes       |
| `storageclass`                   | Storage class to be used: Defaulted to `ibmc-file-gold-gid` for Classic Infrastructure. If using a VPC cluster, set to `portworx-rwx-gp3-sc` and make sure Portworx is set up on cluster  | `ibmc-file-gold-gid`         | Yes       |
| `entitled_registry_key`            | Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary.   |                             | Yes      |
| `entitled_registry_user_email`     | Email address of the user owner of the Entitled Registry Key   |                             | Yes      |

