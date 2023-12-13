terraform {
  required_version = ">= 1.0.0"
}

resource "helm_release" "gpu-operator" {
  name             = var.helmReleaseName
  repository       = "https://helm.ngc.nvidia.com/nvidia"
  chart            = "gpu-operator"
  version          = var.helmChartVersion
  namespace        = var.namespace
  create_namespace = true
  values           = [templatefile("${path.module}/gpu-operator-values.yaml", { driver_version = var.gpuDriverVersion })]
}
