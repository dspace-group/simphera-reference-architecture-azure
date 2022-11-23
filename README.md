# SIMPHERA Reference Architecture for Azure

This repository contains the reference architecture of the infrastructure needed to deploy dSPACE SIMPHERA to the Azure Public Cloud. It does not contain the helm chart needed to deploy SIMPHERA itself, but only the base infrastructure such as Kubernetes, PostgreSQL, storage accounts, etc.

You can use the reference architecture as a starting point for your SIMPHERA installation if you plan to deploy SIMPHERA to Azure. You can use the reference architecture as is and only have to configure few individual values. If you have special requirements feel free to adapt the architecture to your needs. For example, the reference architecture does not contain any kind of VPN connection to a private, on-premise network because this is highly specific. But the reference architecture is configured in such a way that the ingress points are available in the public internet.

Using the reference architecture you can deploy a single or even multiple instances of SIMPHERA, e.g. one for _production_ and one for _testing_.

## Terraform

This reference architecture is provided as a [Terraform](https://terraform.io/) configuration. Terraform is an open-source command line tool to automatically create and manage cloud resources. A Terraform configuration consists of various `.tf` text files. These files contain the specifications of the resources to be created in the cloud infrastructure. That is the reason why this approach is called _infrastructure-as-code_. The main advantage of this approach is _reproducibility_ becaue the configuration can be mainted in a source control system such as Git.

### Variables

Terraform uses _variables_ to make the specification configurable. The concrete values for these variables are specified in `.tfvars` files. So it is the task of the administrator to fill the `.tfvars` files with the correct values. This is explained in more detail in a later chapter.

### State

Terraform has the concept of a _state_. On the one hand side there are the resource specifications in the `.tf` files. On the other hand there are the resources in the cloud infrastructure that are created based on these files. Terraform needs to store _mapping information_ which element of the specification belongs to which resource in the cloud infrastructure. This mapping is called the _state_. In general you could store the state on your local hard drive. But that is not a good idea because in that case nobody else could change some settings and apply these changes. Therefore the state itself should be stored in the cloud.

So you need to manually create a storage account in Azure before you can start using Terraform. This is explained in more detail in the section _Prerequisites_.

## Overview

As mentioned before, the reference architecture is defined as a _Terraform configuration_. It has been tested with Terraform version v1.0.0.

The following figure shows the main resources of the architecture.
The figure shows using Azure Database for PostgreSQL and Private Link. This configuration is recommended by dSPACE. The general purpose tier for the Postgresql server is required to use the private link. The reference architecture also supports the basic tier. In this case, instead of the private link, firewall rules are used that only allow access from within the Kubernetes cluster.

![SIMPHERA Reference Architecture fur Azure](AzureReferenceArchitecture.drawio.png)

## Prerequisites

Before you start you need an Azure subscription and the `contributor` role to create the resources needed for SIMPHERA. Additionally, you need to create the following resources that are not part of this Terraform configuration:

- _Storage Account_: A storage account with Performance set to `standard` and account kind set to `StorageV2 (general purpose v2)` is needed to store the Terraform state. You also have to create a container for the state inside the storage account.
- _KeyVault_: The keys to encrypt the disks of the virtual machine for the license server need to be stored in an Azure KeyVault. The KeyVault is not managed by Terraform and has to be created manually (see Azure KeyVault section).
- _Log Analytics Workspace_ (optional): In order to store the log data of the services you have to provide such a workspace inside your subscription.

On your administration PC you need to install the [Terraform](https://terraform.io/) command, the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) and `ssh-keygen` which is typically available on most operating systems.

## Authentication

To login to Azure, use:

```sh
az login
```

To switch to the correct subscription you can use the following command:

```sh
az account set --subscription "My Subscription"
```

## Clone Repository

If you did not already clone this Git repository please clone it now to your local administration PC.

## SSH Keys

In order to be able to connect to the Kubernetes nodes using _ssh_ you need to create private _ssh keys_. You have to create such keys by executing the following command in the _root_ folder:

```sh
# bash
ssh-keygen -t rsa -b 2048 -f shared-ssh-key/ssh -q -N ""

# Powershell
ssh-keygen -t rsa -b 2048 -f shared-ssh-key/ssh -q -N """"
```

## Azure KeyVault

To create a new Azure KeyVault with the key for Azure Disk Encryption, use the following Powershell script.
Make sure to adjust the variables `$keyVaultResourceGroup`, `$keyVault` and `$location` and enter them also in your tfvars file.
The Powershell snippet prints the `encryptionKeyUrl`. 
Also copy the line that is printed to the console into your tfvars file.
You can read more about [Azure Disk Encryption](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/disk-encryption-portal-quickstart) in the Azure documentation.

```powershell
# Create the KeyVault
$keyVaultResourceGroup = "<resource group>"
$keyVault = "<keyvault name>"
$location = "<azure location>"
az group create --location $location --name $keyVaultResourceGroup
az keyvault create --resource-group $keyVaultResourceGroup --name $keyVault --location $location --enabled-for-disk-encryption

# Create a key that is used for Azure Disk Encryption feature of the license server
az keyvault key create --name "AzureDiskEncryption" --vault-name $keyVault
$key = az keyvault key show --name "AzureDiskEncryption" --vault-name $keyVault | ConvertFrom-Json
Write-Host "encryptionKeyUrl=`"$($key.key.kid)`""

# Create credentials for license server
$licenseServerCredentials = @"
{
    "username" : "<your username>",
    "password" : "<your password>"
}
"@ | ConvertFrom-Json | ConvertTo-Json -Compress
$licenseServerCredentials = $licenseServerCredentials -replace '([\\]*)"', '$1$1\"'
az keyvault secret set --name "license_server" --vault-name $keyVault --value $licenseServerCredentials

# Create credentials for postgresql (one per SIMPHERA instance)
$postgresqlCredentials = @"
{
    "postgresql_username" : "<your username>",
    "postgresql_password" : "<your password>"
}
"@ | ConvertFrom-Json | ConvertTo-Json -Compress
$postgresqlCredentials = $postgresqlCredentials -replace '([\\]*)"', '$1$1\"'
az keyvault secret set --name "<secret name>" --vault-name $keyVault --value $postgresqlCredentials
```
:warning: The usernames for the license and postgresql server should not be changed once the resources are created.
Changing the usernames would force the replacement of the resources what would result in data loss.

The username and password need to satisfy [special requirements](https://learn.microsoft.com/en-us/rest/api/compute/virtual-machines/create-or-update?tabs=HTTP#osprofile). 
The username of the license server must not be one of these: "administrator", "admin", "user", "user1", "test", "user2", "test1", "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console", "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0", "sys", "test2", "test3", "user4", "user5"<sup>.

The supplied password must be between 8-123 characters long and must satisfy at least 3 of password complexity requirements from the following:
1. Contains an uppercase character
2. Contains a lowercase character
3. Contains a numeric digit
4. Contains a special character
5. Control characters are not allowed



Add the configuration to your tfvars file:
```diff
+keyVault="<keyvault name>"
+keyVaultResourceGroup="<resource group>"
+encryptionKeyUrl="https://..."
simpheraInstances = {
  "production" = {
+    secretname = "<secret name>"
    }
}  
```

To get a list of all postgresql passwords run the following command:
```powershell
$secretnames = terraform output -json secretnames | ConvertFrom-Json
foreach($prop in $secretnames.PsObject.Properties)
{
    $secret = az keyvault secret show --name $prop.Value --vault-name $keyVault | ConvertFrom-Json
    $value = $secret.value | ConvertFrom-Json
    $password = ConvertTo-SecureString $value.postgresql_password -AsPlainText -Force
    Remove-Variable secret
    Remove-Variable value
    $password
}
```


To get a list of all storage account keys run the following command:
```powershell
$storageaccounts = terraform output -json minio_storage_usernames | ConvertFrom-Json
foreach($prop in $storageaccounts.PsObject.Properties)
{

  $keys = az storage account keys list -n $prop.value | ConvertFrom-Json
  $access_key = ConvertTo-SecureString $keys[0].value -AsPlainText -Force
  Remove-Variable $keys
  $access_key
}

```



## State

As mentioned before Terraform stores the state of the resources it creates within a container of an Azure storage account. Therefore, you need to specify this location.

To do so, please make a copy of the file `state-backend-template`, name it `state-backend.tf` and open the file in a text editor. The values have to point to an existing storage account to be used to store the Terraform state:

* `resource_group_name`: The name of the resource group your storage account is located in.
* `storage_account_name`: The name of the storage account.
* `container_name`: The name of the container inside the storage account to be used to store the terraform state. You need to create this container manually.
* `key`: The name of the file to be used inside the container to be used for this terraform state.
* `environment`: Use the value `public` for the general Azure cloud.

## Configuration

For your configuration, please make a copy of the file `terraform.tfvars.example`, name it `terraform.tfvars` and open the file in a text editor. This file contains all variables that are configurable including documentation of the variables. Please adapt the values before you deploy the resources.
It is recommended to restrict the access to the Kubernetes API server using authorized IP address ranges by setting the variable `apiServerAuthorizedIpRanges`.

### Mandatory Variables

Here is the list of the variables that you must change in `terraform.tfvars`:

* `subscriptionId`: The ID of the Azure subscription you want to deploy SIMPHERA to
* `location`: The name of the Azure region you want to deploy SIMPHERA to
* `infrastructurename`: The name of this infrastructure. This name will also be used as a prefix for various Azure resource groups. So please choose it carefully.
* `licenseServerAdminPassword`: The password for the user `cluster` of the Windows VM used as the license server.
* `simpheraInstances`: As mentioned before you can configure multiple instances of SIMPHERA, such as _staging_ and _production_. This variable contains a map of these instances. Per instance you must set the following variables:
  * `name`: The name of the instance. This name will also be used as a prefix for various Azure resource groups.
  * `postgresqlAdminPassword`: The password for the user `dbuser` of the PostgreSQL server.

There are additional, optional variables. These variables are documented inside the `terraform.tfvars` file.


## Deployment

Before you can deploy the resources to Azure you have to initialize Terraform:

```sh
terraform init
```

Afterwards you can deploy the resources:

```sh
terraform apply
```
Terraform automatically loads the variables from your `terraform.tfvars` variable definition file.

## MinIO Storage

For each configured SIMPHERA instance an individual Azure storage account is created to store binary artifacts. The name of the storage account is a concatenation of the _infrastructurename_ and the _instancename_, where hyphens are removed and which is clipped to a maximum of 24 characters. Please open the Azure Portal and navigate to the storage account which is located inside the resource group `<instancename>-storage`. Later during the configuration of the SIMPHERA Helm Chart you need the name of this storage account and also an _Access Key_ that is also accessible from the portal.

## Kubernetes

This deployment contains a managed Kubernetes cluster (AKS). In order to use command line tools such as `kubectl` or `helm` you need a _kubeconfig_ configuration file. This file will automatically be exported by Terraform under the filename `<infrastructurename>.kubeconfig`.

If you want to _ssh_ into a Kubernetes worker node you can use a command like this:

```sh
ssh -i shared-ssh-key/ssh simphera@<name-or-ip-of-node>
```

But please keep in mind that the nodes themselves do not get _public IPs_. Therefore you may need to create a _Linux jumpbox VM_ within your virtual network to be able to connect to a node from there. In that case you have to copy the private key to that machine and have to set the correct file access: `chmod 600 shared-ssh-key/ssh`. As an alternative you can use the _License Server Windows VM_ as jumpbox.

## Azure Policy

This reference architecture deploys [Azure Policy](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-for-kubernetes) into the Kubernetes cluster. 
With Azure Policy, security policies can be defined and violations monitored. 
Azure provides various predefined policies. 
By default, no policies are assigned to the Kubernetes cluster using the reference architecture. 
Instead, an administrator must assign policies manually which requires appropriate permissions.
The Azure built-in roles *Resource Policy Contributor* and *Owner* have these permissions.
Using the predefined policy [*Kubernetes cluster containers should only use allowed images*](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policyDefinitions/Kubernetes/ContainerAllowedImages.json) is recommended by dSPACE.
To do this, use the CLI command below:

```powershell
$clustername = "<cluster name>"
$resourcegroup = "<cluster resource group>"
$cluster = az aks show --name $clustername --resource-group $resourcegroup | ConvertFrom-Json
$name = "K8sAzureContainerAllowedImages@${clustername}"
$description = "Kubernetes cluster containers should only use allowed images"
$scope = $cluster.id
$policy = "febd0533-8e55-448f-b837-bd0e06f16469"
$allowedContainerImagesRegex = "^(docker\.io\/(groundnuty|jboss|eclipse-mosquitto|bitnami)|quay\.io\/oauth2-proxy|registry\.dspace\.cloud|registry\.k8s\.io)\/.+$"
$params_ = @"
{
  "allowedContainerImagesRegex": {
    "value": "$allowedContainerImagesRegex" 
  }
}
"@
$params_ = $params_ -replace '\s',''
$params = $params_ -replace '([\\]*)"', '$1$1\"'
az policy assignment create `
  --scope $scope `
  --description $description `
  --name $name `
  --policy $policy `
  --params $params
```

## Delete Resources

To delete all resources you have to execute the following command:

```sh
terraform destroy
```

Please keep in mind that this command will also delete all storage accounts including your backups. So please be careful.

## Next steps

As a next step you have to deploy SIMPHERA to the Kubernetes cluster by using the SIMPHERA Quick Start helm chart. You will find detailed instructions in the README file inside the Helm chart itself.
