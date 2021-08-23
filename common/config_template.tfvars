# The ID of the Azure subscription to be used
subscriptionId = "xxxxx"

# The Azure environment to be used, either 'public' or 'china'
environment = "public"

# The Azure location to be used
location = "westeurope"

# The name of the infrastructure. e.g. simphera-infra
infrastructurename = "simphera-infra"

# The tags to be added to all resources
tags = {}

# The machine size of the Linux nodes for the regular services
linuxNodeSize = "Standard_D4s_v3"

# The minimum number of Linux nodes for the regular services
linuxNodeCountMin = 1

# The maximum number of Linux nodes for the regular services
linuxNodeCountMax = 10

# The machine size of the Linux nodes for the job execution
linuxExecutionNodeSize = "Standard_D4s_v3"

# The minimum number of Linux nodes for the job execution
linuxExecutionNodeCountMin = 0

# The maximum number of Linux nodes for the job execution
linuxExecutionNodeCountMax  = 10

# Path to the public SSH key to be used for the kubernetes nodes
ssh_public_key_path = "shared-ssh-key/ssh.pub"

# Path to the private SSH key to be used for the kubernetes nodes
ssh_private_key_path = "shared-ssh-key/ssh"

# Specifies whether a VM for the dSPACE Installation Manager will be deployed
licenseServer = false

# Login name of the local user of the license server
licenseServerAdminLogin = "cluster"

# Password of the local user of the license server
licenseServerAdminPassword = "Foobar1234"

# The name of the Log Analytics Workspace to be used. Use empty string to disable usage of Log Analytics.
logAnalyticsWorkspaceName = ""

#  The name of the resource group of the Log Analytics Workspace to be used.
logAnalyticsWorkspaceResourceGroupName = ""

# The version of the AKS cluster.
kubernetesVersion = "1.20.7"
