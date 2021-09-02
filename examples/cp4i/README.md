# Example to provision CP4I Terraform Module

## Run using IBM Cloud Schematics

For instructions to run these examples using IBM Schematics go [here]([../Using_Schematics.md](https://cloud.ibm.com/docs/schematics?topic=schematics-get-started-terraform))

For more information on IBM Schematics, refer [here](https://cloud.ibm.com/docs/schematics?topic=schematics-get-started-terraform).

## Run using local Terraform Client

For instructions to run using the local Terraform Client on your local machine go [here]([../Using_Terraform.md](https://ibm.github.io/cloud-enterprise-examples/iac/setup-environment/)). 


### Inputs

| Name                               | Description  | Default                     | Required |
| ---------------------------------- | ----- | --------------------------- | -------- |
| `cluster_id`                       | ID of the cluster to install cloud pak on. Cluster needs to be at least 4 nodes of size 16x64.|                             | Yes       |
| `resource_group`                   | Resource Group in your account to host the cluster. List all available resource groups with: `ibmcloud resource groups`     | `cloud-pak-sandbox`         | Yes       |
| `storageclass`                   | Storage class to be used: Defaulted to `ibmc-file-gold-gid` for Classic Infrastructure. If using a VPC cluster, set to `portworx-rwx-gp3-sc` and make sure Portworx is set up on cluster  | `ibmc-file-gold-gid`         | Yes       |
| `entitled_registry_key`            | Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary.   |                             | Yes      |
| `entitled_registry_user_email`     | Email address of the user owner of the Entitled Registry Key   |                             | Yes      |

If running locally, set the desired values for these variables in the `terraform.tfvars` file.  Here are some examples:

```hcl
  cluster_id            = "******************"
  storageclass          = "ibmc-file-gold-gid"
  resource_group_name   = "Default"
  entitled_registry_key = "******************"
  entitled_registry_user_email = "john.doe@email.com"
```

### Execute the example

Execute the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### Verify

To verify installation on the cluster, on the Openshift console go to the `Installed Operators` tab. Choose your `namespace` and click on `IBM Cloud Pak for Integration Platform Navigator
4.2.0 provided by IBM`. Click on the `Platform Navigator` tab. Check the status of the cp4i-navigator

### Cleanup

Go into the console and delete the platform navigator from the verify section. Delete all installed operators and lastly delete the project.

Finally, execute: `terraform destroy`.

If running locally, There are some directories and files you may want to manually delete, these are: `rm -rf terraform.tfstate* .terraform .kube`