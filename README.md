# SIMPHERA Reference Architecture for Azure

This repository contains the reference architecture of the infrastructure needed to deploy dSPACE SIMPHERA to the Azure Public Cloud. It does not contain the helm chart needed to deploy SIMPHERA itself, but only the base infrastructure such as Kubernetes, PostgreSQL, storage accounts, etc.

You can use the reference architecture as a starting point for your SIMPHERA installation if you plan to deploy SIMPHERA to Azure. You can use the reference architecture as it is and only have to configure few individual values. If you have special requirements feel free to adapt the architecture to your needs. For example, the reference architecture does not contain any kind of VPN connection to a private, on-premise network because this is highly user specific. But the reference architecture is configured in such a way that the ingress points are available in the public internet.

Using the reference architecture you can deploy a single or even multiple instances of SIMPHERA, e.g. one for _production_ and one for _testing_.

## Overview

The reference architecture is defined as _Terraform configurations_. It is devided into two sections:

1. `common`: As mentioned before this reference architecture supports the deployment of a single instance or multiple instances of SIMPHERA. Some Azure resources will be shared between these instances. These resources are defined in the `common` section.
2. `instance`: This section contains the SIMPHERA instance specific Azure resources.

Both folders contain separate Terraform configurations that have to be applied individually. So please keep in mind to first apply the _common_ section and afterwards apply the _instance_ section.

This repository has been tested with Terraform version v1.0.0.

The following figure shows the main resources of the architecture:

![SIMPHERA Reference Architecture fur Azure](AzureReferenceArchitecture.png)

## Prerequisites

Before you start you need an Azure subscription and typically the `contributor` role to create the resources needed for SIMPHERA. Additionally, you need to create the following resources that are not part of this Terraform configuration:

- _Storage Account_: A storage account with Performance set to `standard` and account kind set to `StorageV2 (general purpose v2)` is needed to store the Terraform state. You also have to create a container for the state inside the storage account.
- _Log Analytics Workspace_ (optional): In order to store the log data of the services you have to provide such a workspace inside your subscription.

### Authentication

Authentication to Azure is done via [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/). Terraform only supports authenticating using the `az` CLI (which must be available on your PATH) - authenticating using the older `azure` CLI is not supported.

To login to the Azure CLI, use

```sh
az login
```

If you plan on using the _China_ Azure Cloud, you'll first need to configure the Azure CLI to work with that cloud. You can do this by running:

```sh
az cloud set --name AzureChinaCloud
```

## Common

The common section creates the following Azure resources:

- _Virtual Network_: A virtual network with multiple subnets used for all services, endpoints, etc.
- _Azure Kubernetes Service_: A managed Kubernetes cluster including two node pools.
- _Private DNS zones_: Private DNS zones for PostgreSQL.
- _Virtual machine_: A virtual Windows machine to be used as license server.

### Configuration

If you did not already clone this Git repository please clone it now to your local administration PC.

For your configuration, make a copy of the file `config_template.tfvars` named `config.tfvars` and make your changes in this copy. This file contains all variables that are configurable including the documentation of the variables. Please adapt the values before you deploy the resources.

In order to be able to connect to the Kubernetes nodes using _ssh_ you need to create _ssh keys_. You can create such keys by executing the following command in the `common` folder:

```sh
# bash
cd common
ssh-keygen -t rsa -b 2048 -f shared-ssh-key/ssh -q -N ""

# Powershell
cd common
ssh-keygen -t rsa -b 2048 -f shared-ssh-key/ssh -q -N """"
```

Terraform stores the state of the resources it creates within a container of an Azure storage account. Therefore, you need to specify this location.
To do so, you have to make a copy of the file `state-backend-template` named `state-backend.tf` where you can make your individual changes. The values have to point to the existing storage account to be used to store the Terraform state:

* `resource_group_name`: The name of the resource group your storage account is located in.
* `storage_account_name`: The name of the storage account that you created before.
* `container_name`: The name of the container inside the storage account to be used to store the terraform state. You need to create this container manually.
* `key`: The name of the file to be used inside the container to be used for this specific terraform state.
* `environment`: Use the value `public` for the general Azure cloud or `china` for Azure China.

#### Azure China

If you want to create your infrastructure in an Azure China subscription, you need to adjust both _environment_ in `config.tfvars` and in `state-backend.tf` to "china".

### Deployment

To deploy the common part, you first have to login to your Azure subscription and initialize Terraform:

```sh
cd common
az account set --subscription "My Subscription"
terraform init
```

Afterwards you can deploy the resources:

```sh
terraform apply -var-file="config.tfvars"
```

### Deleting

To delete all resources you have to execute the following command:

```sh
terraform destroy -var-file="config.tfvars"
```

### Kubernetes

This _common_ part includes a deployment of a managed kubernetes cluster (AKS). In order to use command line tools such as `kubectl` or `helm` you need a _kubeconfig_ configuration file. This file will automatically be exported by terraform under the filename `<infrastructurename>.kubeconfig`.

Alternatively, you can use the following Azure CLI command to load the _kubeconfig_ file. This command will add the configuration of the new cluster to your default _kubeconfig_ file:

```sh
az aks get-credentials --resource-group <infrastructurename>-aks --name <infrastructurename>-aks
```

If you want to _ssh_ into a node you can use a command like this:

```sh
ssh -i shared-ssh-key/ssh simphera@<name-or-ip-of-node>
```

But please keep in mind that the nodes themselves do not get _public IPs_. Therefore you may need to create a _Linux jumpbox VM_ within your virtual network to be able to connect to a node from there. In that case you have to copy the private key to that machine and have to set the correct file access: `chmod 600 shared-ssh-key/ssh`. As an alternative you can use the _License Server Windows VM_ as jumpbox.

## Instance

The instance section creates the following Azure resources:

- _PostgreSQL Server_: A managed PostgreSQL server including two database of _SIMPHERA_ and _Keycloak_. Additionally, a private endpoint is added to the _paas_ subnet.
- _Storage Account_: A standard account used to store the binary artifacts. This will be used by MinIO.
- _Storage Account_: A standard account used to store CouchDB backup archive files.

_Note:_ The `instance` folder contains a separate terraform configuration.

### Configuration

This folder has a similar structure as the `common` folder. You also have to copy the template files and name them `config.tfvars` and `state-backend.tf`.
To store the Terraform state of the SIMPHERA instance, you can use the same storage account and container used for the common infrastructure as configured in `common/state-backend.tf`, but in that case you must use a different key in `instance/state-backend.tf`, because otherwise Terraform will delete all your common resources:

```diff
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "simpherainfra"
    container_name       = "terraformstate"
-   key                  = "common.tfstate"
+   key                  = "instance.tfstate"
  }
}
```

In the `config.tvfars` file you have to set the values `subscriptionId`, `environment`, `location` and `infrastructurename` to exactly the same values as for the _common_ part. The value `instancename` represents the name of your SIMPHERA instance, such as `production` or `testing`.

### Deployment

The deployment of the instance specific part follows exactly the same pattern as for the _common_ part. I.e. you also have to execute both `terraform init` and `terraform apply` inside the `instance` folder.

## Next steps

As a next step you have to deploy SIMPHERA to the Kubernetes cluster by using the SIMPHERA Quick Start helm chart. You will find detailed instructions in the README file inside the helm chart itself.
