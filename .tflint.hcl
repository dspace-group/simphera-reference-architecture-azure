plugin "azurerm" {
    enabled = true
    version = "0.20.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_required_providers" {
  enabled = false
}