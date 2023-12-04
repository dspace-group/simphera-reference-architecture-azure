terraform {
  required_version = ">= 1.0.0"
}

resource "helm_release" "gpu-operator" {
  name       = var.helmReleaseName
  repository = "https://helm.ngc.nvidia.com/nvidia"
  chart      = "gpu-operator"
  version    = var.helmChartVersion
  values     = [templatefile("./gpu-operator-values.yaml", { driver_version = var.gpuDriverVersion })]
}
