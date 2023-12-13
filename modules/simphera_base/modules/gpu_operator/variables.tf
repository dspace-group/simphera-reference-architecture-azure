variable "gpuDriverVersion" {
  type = string
}

variable "helmReleaseName" {
  type    = string
  default = "gpu-operator"
}

variable "helmChartVersion" {
  type    = string
  default = "v23.9.0"
}

variable "namespace" {
  type    = string
  default = "gpu-operator"
}
