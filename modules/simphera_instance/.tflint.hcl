config {
#Enables module inspection
    module = true
    force = false
}

plugin "azurerm" {
    enabled = true
    version = "0.20.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}