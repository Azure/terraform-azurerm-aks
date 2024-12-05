# tflint-ignore-file: terraform_standard_module_structure

variable "agents_taints" {
  type        = list(string)
  default     = null
  description = "DEPRECATED, (Optional) A list of the taints added to new nodes during node pool create and scale. Changing this forces a new resource to be created."
}

variable "api_server_subnet_id" {
  type        = string
  default     = null
  description = "DEPRECATED, (Optional) The ID of the Subnet where the API server endpoint is delegated to."
}

variable "rbac_aad_client_app_id" {
  type        = string
  default     = null
  description = "DEPRECATED, The Client ID of an Azure Active Directory Application."
}

variable "rbac_aad_server_app_id" {
  type        = string
  default     = null
  description = "DEPRECATED, The Server ID of an Azure Active Directory Application."
}

variable "rbac_aad_server_app_secret" {
  type        = string
  default     = null
  description = "DEPRECATED, The Server Secret of an Azure Active Directory Application."
}