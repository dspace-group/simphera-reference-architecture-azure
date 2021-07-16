# The ID of the Azure subscription to be used
subscriptionId = "xxxxx"

# The Azure location to be used
location = "westeurope"

# The name of the infrastructure. e.g. simphera-infra
infrastructurename = "simphera-infra"

# The tags to be added to all resources
tags = {}

# The name of the cluster. e.g. production
instancename = "production"

# The type of replication for the storage account. Can be LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS.
minioAccountReplicationType = "ZRS"

# Login name of the account for the PostgreSQL Server
postgresqlAdminLogin = "dbuser"

# Password of the account for the PostgreSQL Server
postgresqlAdminPassword = "foobar1234"

# PostgreSQL Server version to deploy
postgresqlVersion = "11"

# PostgreSQL SKU Name
postgresqlSkuName = "GP_Gen5_4"

# PostgreSQL Storage in MB, must be divisble by 1024
postgresqlStorage = 640000