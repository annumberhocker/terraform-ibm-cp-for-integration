# IBM Cloud Pak for Integration - Terraform Module

This is a module and example to make it easier to provision Cloud Pak for Integration on an IBM Cloud Platform OpenShift Cluster provisioned on either Classic of VPC infrastructure.  The cluster is required to contain at least 4 nodes of size 16x64. If VPC is used, Portworx is required to provide necessary storage classes.

## Compatibility

This module is meant for use with Terraform 0.13 (and higher).

## Usage

A full example is in the [examples](./examples/) folder.

e.g:

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

## Requirements

### Terraform plugins

- [Terraform](https://www.terraform.io/downloads.html) 0.13 (or later)
- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

## Install

### Terraform

Be sure you have the correct Terraform version (0.13), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

### Terraform plugins

Be sure you have the compiled plugins on $HOME/.terraform.d/plugins/

- [terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

### Pre-commit hooks

Run the following command to execute the pre-commit hooks defined in .pre-commit-config.yaml file
```
pre-commit run -a
```
You can install pre-coomit tool using

```
pip install pre-commit
```
or
```
pip3 install pre-commit
```
## How to input variable values through a file

To review the plan for the configuration defined (no resources actually provisioned)
```
terraform plan -var-file=./input.tfvars
```
To execute and start building the configuration defined in the plan (provisions resources)
```
terraform apply -var-file=./input.tfvars
```

To destroy all related resources
```
terraform destroy -var-file=./input.tfvars
```

## Note

