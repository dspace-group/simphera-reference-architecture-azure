# The ID of the Azure subscription to be used
# Note: This value must be the same as in your 'common' configuration.
subscriptionId = "xxxxx"

# The Azure environment to be used
# Note: This value must be the same as in your 'common' configuration.
environment = "public"

# The Azure location to be used
# Note: This value must be the same as in your 'common' configuration.
location = "westeurope"

# The name of the infrastructure. e.g. simphera-infra
# Note: This value must be the same as in your 'common' configuration.
infrastructurename = "simphera-infra"

# The tags to be added to all resources
tags = {}

# The name of the cluster. e.g. production
# This name will also be used as a prefix to the resource group names created by terraform.
instancename = "production"

# The type of replication for the storage account. Can be LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS.
minioAccountReplicationType = "ZRS"

# Login name of the account for the PostgreSQL Server
postgresqlAdminLogin = "dbuser"

# Password of the account for the PostgreSQL Server
postgresqlAdminPassword = "Foobar1234"

# PostgreSQL Server version to deploy
postgresqlVersion = "11"

# PostgreSQL SKU Name
postgresqlSkuName = "GP_Gen5_2"

# PostgreSQL Storage in MB, must be divisble by 1024
postgresqlStorage = 5120