
# VS Code
It is recommended to use VS Code for the development of the reference architecture.
The extension that is used for Terraform development is [hashicorp.terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).
The `.vscode` folder contains a `settings.json` applies the canonial formatting on every `.tf` and `.tfvars` inside the workspace.

# Pre-commit hook

It is also recommended to install the [pre-commit](https://pre-commit.com/) hook on your development machine.
You can install the hook using these commands on Windows:

```powershell
choco install python
pip install pre-commit
pre-commit install
```

The hook is configured in `.pre-commit-config.yaml`.
The hooks calls [`terraform fmt`](https://developer.hashicorp.com/terraform/cli/commands/fmt) and [`terraform validate`](https://developer.hashicorp.com/terraform/cli/commands/validate) on every `git commit`.

# GitHub Workflow

In addition, there is a GitHub Workflow defined in `.github/workflows/qualitygate.yml` that runs `terraform fmt` and `terraform validate` when a pull request is created.





