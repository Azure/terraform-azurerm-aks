variable "service_mesh_profile" {
  type = object({
    mode                             = string
    revisions                        = list(string)
    internal_ingress_gateway_enabled = optional(bool, true)
    external_ingress_gateway_enabled = optional(bool, true)
  })
  default     = null
  description = <<-EOT
    `mode` - (Required) The mode of the service mesh. Possible value is `Istio`.
    `revisions` - (Required) Specify 1 or 2 Istio control plane revisions for managing minor upgrades using the canary upgrade process. For example, create the resource with `revisions` set to `["asm-1-20"]`, or leave it empty (the `revisions` will only be known after apply). To start the canary upgrade, change `revisions` to `["asm-1-20", "asm-1-21"]`. To roll back the canary upgrade, revert to `["asm-1-20"]`. To confirm the upgrade, change to `["asm-1-21"]`.
    `internal_ingress_gateway_enabled` - (Optional) Is Istio Internal Ingress Gateway enabled? Defaults to `true`.
    `external_ingress_gateway_enabled` - (Optional) Is Istio External Ingress Gateway enabled? Defaults to `true`.
  EOT
}