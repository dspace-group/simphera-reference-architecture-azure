plugin "azurerm" {
    enabled = true
    version = "0.58.1"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Disable this rules for the modules
rule "terraform_required_providers" {
  enabled = false
}
