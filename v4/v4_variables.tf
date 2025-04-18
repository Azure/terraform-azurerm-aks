variable "upgrade_override" {
  type = object({
    force_upgrade_enabled = bool
    effective_until       = optional(string)
  })
  default     = null
  description = <<-EOT
    `force_upgrade_enabled` - (Required) Whether to force upgrade the cluster. Possible values are `true` or `false`.
    `effective_until` - (Optional) Specifies the duration, in RFC 3339 format (e.g., `2025-10-01T13:00:00Z`), the upgrade_override values are effective. This field must be set for the `upgrade_override` values to take effect. The date-time must be within the next 30 days.
  EOT
}
