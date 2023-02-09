variable "prefix" {
  type        = string
  description = "(Required) The prefix for the resources created in the specified Azure Resource Group"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name to be imported"
}

variable "aci_connector_linux_enabled" {
  description = "Enable Virtual Node pool"
  type        = bool
  default     = false
}

variable "aci_connector_linux_subnet_name" {
  description = "(Optional) aci_connector_linux subnet name"
  type        = string
  default     = null
}

variable "admin_username" {
  type        = string
  description = "The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created."
  default     = null
}

variable "agents_availability_zones" {
  type        = list(string)
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  default     = null
}

variable "agents_count" {
  type        = number
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  default     = 2
}

variable "agents_labels" {
  type        = map(string)
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  default     = {}
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
  default     = null
}

variable "agents_max_pods" {
  type        = number
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  default     = null
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = null
}

variable "agents_pool_name" {
  type        = string
  description = "The default Azure AKS agentpool (nodepool) name."
  default     = "nodepool"
  nullable    = false
}

variable "agents_size" {
  type        = string
  description = "The default virtual machine size for the Kubernetes agents"
  default     = "Standard_D2s_v3"
}

variable "agents_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the Node Pool."
  default     = {}
}

variable "agents_type" {
  type        = string
  description = "(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  default     = "VirtualMachineScaleSets"
}

variable "api_server_authorized_ip_ranges" {
  type        = set(string)
  description = "(Optional) The IP ranges to allow for incoming traffic to the server nodes."
  default     = null
}

variable "auto_scaler_profile_balance_similar_node_groups" {
  description = "Detect similar node groups and balance the number of nodes between them. Defaults to `false`."
  type        = bool
  default     = false
}

variable "auto_scaler_profile_empty_bulk_delete_max" {
  description = "Maximum number of empty nodes that can be deleted at the same time. Defaults to `10`."
  type        = number
  default     = 10
}

variable "auto_scaler_profile_enabled" {
  type        = bool
  description = "Enable configuring the auto scaler profile"
  default     = false
  nullable    = false
}

variable "auto_scaler_profile_expander" {
  description = "Expander to use. Possible values are `least-waste`, `priority`, `most-pods` and `random`. Defaults to `random`."
  type        = string
  default     = "random"
  validation {
    condition     = contains(["least-waste", "most-pods", "priority", "random"], var.auto_scaler_profile_expander)
    error_message = "Must be either `least-waste`, `most-pods`, `priority` or `random`."
  }
}

variable "auto_scaler_profile_max_graceful_termination_sec" {
  description = "Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to `600`."
  type        = string
  default     = "600"
}

variable "auto_scaler_profile_max_node_provisioning_time" {
  description = "Maximum time the autoscaler waits for a node to be provisioned. Defaults to `15m`."
  type        = string
  default     = "15m"
}

variable "auto_scaler_profile_max_unready_nodes" {
  description = "Maximum Number of allowed unready nodes. Defaults to `3`."
  type        = number
  default     = 3
}

variable "auto_scaler_profile_max_unready_percentage" {
  description = "Maximum percentage of unready nodes the cluster autoscaler will stop if the percentage is exceeded. Defaults to `45`."
  type        = number
  default     = 45
}

variable "auto_scaler_profile_new_pod_scale_up_delay" {
  description = "For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age. Defaults to `10s`."
  type        = string
  default     = "10s"
}

variable "auto_scaler_profile_scale_down_delay_after_add" {
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to `10m`."
  type        = string
  default     = "10m"
}

variable "auto_scaler_profile_scale_down_delay_after_delete" {
  description = "How long after node deletion that scale down evaluation resumes. Defaults to the value used for `scan_interval`."
  type        = string
  default     = null
}

variable "auto_scaler_profile_scale_down_delay_after_failure" {
  description = "How long after scale down failure that scale down evaluation resumes. Defaults to `3m`."
  type        = string
  default     = "3m"
}

variable "auto_scaler_profile_scale_down_unneeded" {
  description = "How long a node should be unneeded before it is eligible for scale down. Defaults to `10m`."
  type        = string
  default     = "10m"
}

variable "auto_scaler_profile_scale_down_unready" {
  description = "How long an unready node should be unneeded before it is eligible for scale down. Defaults to `20m`."
  type        = string
  default     = "20m"
}

variable "auto_scaler_profile_scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to `0.5`."
  type        = string
  default     = "0.5"
}

variable "auto_scaler_profile_scan_interval" {
  description = "How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to `10s`."
  type        = string
  default     = "10s"
}

variable "auto_scaler_profile_skip_nodes_with_local_storage" {
  description = "If `true` cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath. Defaults to `true`."
  type        = bool
  default     = true
}

variable "auto_scaler_profile_skip_nodes_with_system_pods" {
  description = "If `true` cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods). Defaults to `true`."
  type        = bool
  default     = true
}

variable "automatic_channel_upgrade" {
  type        = string
  default     = null
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are `patch`, `rapid`, `node-image` and `stable`. By default automatic-upgrades are turned off. Note that you cannot use the `patch` upgrade channel and still specify the patch version using `kubernetes_version`. See [the documentation](https://learn.microsoft.com/en-us/azure/aks/auto-upgrade-cluster) for more information"
  validation {
    condition = var.automatic_channel_upgrade == null ? true : contains([
      "patch", "stable", "rapid", "node-image"
    ], var.automatic_channel_upgrade)
    error_message = "`automatic_channel_upgrade`'s possible values are `patch`, `stable`, `rapid` or `node-image`."
  }
}

variable "azure_policy_enabled" {
  type        = bool
  description = "Enable Azure Policy Addon."
  default     = false
}

variable "client_id" {
  type        = string
  description = "(Optional) The Client ID (appId) for the Service Principal used for the AKS deployment"
  default     = ""
  nullable    = false
}

variable "client_secret" {
  type        = string
  description = "(Optional) The Client Secret (password) for the Service Principal used for the AKS deployment"
  default     = ""
  nullable    = false
}

variable "cluster_log_analytics_workspace_name" {
  type        = string
  description = "(Optional) The name of the Analytics workspace"
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "(Optional) The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'prefix' var (The 'prefix' var will still be applied to the dns_prefix if it is set)"
  default     = null
}

variable "disk_encryption_set_id" {
  type        = string
  description = "(Optional) The ID of the Disk Encryption Set which should be used for the Nodes and Volumes. More information [can be found in the documentation](https://docs.microsoft.com/azure/aks/azure-disk-customer-managed-keys). Changing this forces a new resource to be created."
  default     = null
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable node pool autoscaling"
  default     = false
}

variable "enable_host_encryption" {
  type        = bool
  description = "Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli"
  default     = false
}

variable "enable_node_public_ip" {
  type        = bool
  description = "(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false."
  default     = false
}

variable "http_application_routing_enabled" {
  type        = bool
  description = "Enable HTTP Application Routing Addon (forces recreation)."
  default     = false
}

variable "identity_ids" {
  type        = list(string)
  description = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster."
  default     = null
}

variable "identity_type" {
  type        = string
  description = "(Optional) The type of identity used for the managed cluster. Conflicts with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well."
  default     = "SystemAssigned"

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned` and `UserAssigned`"
  }
}

variable "ingress_application_gateway_enabled" {
  type        = bool
  description = "Whether to deploy the Application Gateway ingress controller to this Kubernetes Cluster?"
  default     = false
  nullable    = false
}

variable "ingress_application_gateway_id" {
  type        = string
  description = "The ID of the Application Gateway to integrate with the ingress controller of this Kubernetes Cluster."
  default     = null
}

variable "ingress_application_gateway_name" {
  type        = string
  description = "The name of the Application Gateway to be used or created in the Nodepool Resource Group, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
  default     = null
}

variable "ingress_application_gateway_subnet_cidr" {
  type        = string
  description = "The subnet CIDR to be used to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
  default     = null
}

variable "ingress_application_gateway_subnet_id" {
  type        = string
  description = "The ID of the subnet on which to create an Application Gateway, which in turn will be integrated with the ingress controller of this Kubernetes Cluster."
  default     = null
}

variable "key_vault_secrets_provider_enabled" {
  type        = bool
  description = "(Optional) Whether to use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster. For more details: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver"
  default     = false
  nullable    = false
}

variable "kms_enabled" {
  type        = bool
  description = "(Optional) Enable Azure KeyVault Key Management Service."
  default     = false
  nullable    = false
}

variable "kms_key_vault_key_id" {
  type        = string
  description = "(Optional) Identifier of Azure Key Vault key. When Azure Key Vault key management service is enabled, this field is required and must be a valid key identifier."
  default     = null
}

variable "kms_key_vault_network_access" {
  type        = string
  description = "(Optional) Network Access of Azure Key Vault. Possible values are: `Private` and `Public`."
  default     = "Public"
  validation {
    condition     = contains(["Private", "Public"], var.kms_key_vault_network_access)
    error_message = "Possible values are `Private` and `Public`"
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  default     = null
}

variable "load_balancer_profile_enabled" {
  type        = bool
  description = "(Optional) Enable a load_balancer_profile block. This can only be used when load_balancer_sku is set to `standard`."
  default     = false
  nullable    = false
}

variable "load_balancer_profile_idle_timeout_in_minutes" {
  type        = number
  description = "(Optional) Desired outbound flow idle timeout in minutes for the cluster load balancer. Must be between `4` and `120` inclusive."
  default     = 30
}

variable "load_balancer_profile_managed_outbound_ip_count" {
  type        = number
  description = "(Optional) Count of desired managed outbound IPs for the cluster load balancer. Must be between `1` and `100` inclusive"
  default     = null
}

variable "load_balancer_profile_managed_outbound_ipv6_count" {
  type        = number
  description = "(Optional) The desired number of IPv6 outbound IPs created and managed by Azure for the cluster load balancer. Must be in the range of `1` to `100` (inclusive). The default value is `0` for single-stack and `1` for dual-stack. Note: managed_outbound_ipv6_count requires dual-stack networking. To enable dual-stack networking the Preview Feature Microsoft.ContainerService/AKS-EnableDualStack needs to be enabled and the Resource Provider re-registered, see the documentation for more information. https://learn.microsoft.com/en-us/azure/aks/configure-kubenet-dual-stack?tabs=azure-cli%2Ckubectl#register-the-aks-enabledualstack-preview-feature"
  default     = null
}

variable "load_balancer_profile_outbound_ip_address_ids" {
  type        = set(string)
  description = "(Optional) The ID of the Public IP Addresses which should be used for outbound communication for the cluster load balancer."
  default     = null
}

variable "load_balancer_profile_outbound_ip_prefix_ids" {
  type        = set(string)
  description = "(Optional) The ID of the outbound Public IP Address Prefixes which should be used for the cluster load balancer."
  default     = null
}

variable "load_balancer_profile_outbound_ports_allocated" {
  type        = number
  description = "(Optional) Number of desired SNAT port for each VM in the clusters load balancer. Must be between `0` and `64000` inclusive. Defaults to `0`"
  default     = 0
}

variable "load_balancer_sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are `basic` and `standard`. Defaults to `standard`. Changing this forces a new kubernetes cluster to be created."
  default     = "standard"

  validation {
    condition     = contains(["basic", "standard"], var.load_balancer_sku)
    error_message = "Possible values are `basic` and `standard`"
  }
}

variable "local_account_disabled" {
  type        = bool
  description = "(Optional) - If `true` local accounts will be disabled. Defaults to `false`. See [the documentation](https://docs.microsoft.com/azure/aks/managed-aad#disable-local-accounts) for more information."
  default     = null
}

variable "location" {
  type        = string
  description = "Location of cluster, if not defined it will be read from the resource-group"
  default     = null
}

variable "log_analytics_solution_id" {
  type        = string
  description = "(Optional) Existing azurerm_log_analytics_solution ID. Providing ID disables creation of azurerm_log_analytics_solution."
  default     = null
}

variable "log_analytics_workspace" {
  type = object({
    id   = string
    name = string
  })
  description = "(Optional) Existing azurerm_log_analytics_workspace to attach azurerm_log_analytics_solution. Providing the config disables creation of azurerm_log_analytics_workspace."
  default     = null
}

variable "log_analytics_workspace_enabled" {
  type        = bool
  description = "Enable the integration of azurerm_log_analytics_workspace and azurerm_log_analytics_solution: https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-onboard"
  default     = true
  nullable    = false
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "(Optional) Resource group name to create azurerm_log_analytics_solution."
  default     = null
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  type        = number
  description = "The retention period for the logs in days"
  default     = 30
}

variable "maintenance_window" {
  type = object({
    allowed = list(object({
      day   = string
      hours = set(number)
    })),
    not_allowed = list(object({
      end   = string
      start = string
    })),
  })
  description = "(Optional) Maintenance configuration of the managed cluster."
  default     = null
}

variable "microsoft_defender_enabled" {
  type        = bool
  description = "(Optional) Is Microsoft Defender on the cluster enabled? Requires `var.log_analytics_workspace_enabled` to be `true` to set this variable to `true`."
  default     = false
  nullable    = false
}

variable "net_profile_dns_service_ip" {
  type        = string
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  default     = null
}

variable "net_profile_docker_bridge_cidr" {
  type        = string
  description = "(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  default     = null
}

variable "net_profile_outbound_type" {
  type        = string
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
  default     = "loadBalancer"
}

variable "net_profile_pod_cidr" {
  type        = string
  description = " (Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet. Changing this forces a new resource to be created."
  default     = null
}

variable "net_profile_service_cidr" {
  type        = string
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  default     = null
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to use for networking."
  default     = "kubenet"
  nullable    = false
}

variable "network_policy" {
  type        = string
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  default     = null
}

variable "node_resource_group" {
  type        = string
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster. Changing this forces a new resource to be created."
  default     = null
}

variable "oidc_issuer_enabled" {
  description = "Enable or Disable the OIDC issuer URL. Defaults to false."
  type        = bool
  default     = false
}

variable "only_critical_addons_enabled" {
  type        = bool
  description = "(Optional) Enabling this option will taint default node pool with `CriticalAddonsOnly=true:NoSchedule` taint. Changing this forces a new resource to be created."
  default     = null
}

variable "open_service_mesh_enabled" {
  type        = bool
  description = "Is Open Service Mesh enabled? For more details, please visit [Open Service Mesh for AKS](https://docs.microsoft.com/azure/aks/open-service-mesh-about)."
  default     = null
}

variable "orchestrator_version" {
  type        = string
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  default     = null
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size of nodes in GBs."
  default     = 50
}

variable "os_disk_type" {
  type        = string
  description = "The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. Changing this forces a new resource to be created."
  default     = "Managed"
  nullable    = false
}

variable "pod_subnet_id" {
  type        = string
  description = "(Optional) The ID of the Subnet where the pods in the default Node Pool should exist. Changing this forces a new resource to be created."
  default     = null
}

variable "private_cluster_enabled" {
  type        = bool
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  default     = false
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to `false`."
  default     = false
}

variable "private_dns_zone_id" {
  type        = string
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, `System` to have AKS manage this or `None`. In case of `None` you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created."
  default     = null
}

variable "public_ssh_key" {
  type        = string
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
  default     = ""
}

variable "rbac_aad" {
  type        = bool
  description = "(Optional) Is Azure Active Directory ingration enabled?"
  default     = true
  nullable    = false
}

variable "rbac_aad_admin_group_object_ids" {
  type        = list(string)
  description = "Object ID of groups with admin access."
  default     = null
}

variable "rbac_aad_azure_rbac_enabled" {
  type        = bool
  description = "(Optional) Is Role Based Access Control based on Azure AD enabled?"
  default     = null
}

variable "rbac_aad_client_app_id" {
  type        = string
  description = "The Client ID of an Azure Active Directory Application."
  default     = null
}

variable "rbac_aad_managed" {
  type        = bool
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  default     = false
  nullable    = false
}

variable "rbac_aad_server_app_id" {
  type        = string
  description = "The Server ID of an Azure Active Directory Application."
  default     = null
}

variable "rbac_aad_server_app_secret" {
  type        = string
  description = "The Server Secret of an Azure Active Directory Application."
  default     = null
}

variable "rbac_aad_tenant_id" {
  type        = string
  description = "(Optional) The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used."
  default     = null
}

variable "role_based_access_control_enabled" {
  type        = bool
  description = "Enable Role Based Access Control."
  default     = false
  nullable    = false
}

variable "scale_down_mode" {
  type        = string
  description = "(Optional) Specifies the autoscaling behaviour of the Kubernetes Cluster. If not specified, it defaults to `Delete`. Possible values include `Delete` and `Deallocate`. Changing this forces a new resource to be created."
  default     = "Delete"
}

variable "secret_rotation_enabled" {
  type        = bool
  description = "Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true` and defaults to `false`"
  default     = false
  nullable    = false
}

variable "secret_rotation_interval" {
  type        = string
  description = "The interval to poll for secret rotation. This attribute is only set when `secret_rotation` is `true` and defaults to `2m`"
  default     = "2m"
  nullable    = false
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free` and `Paid`"
  default     = "Free"
}

variable "storage_profile_blob_driver_enabled" {
  type        = bool
  description = "(Optional) Is the Blob CSI driver enabled? Defaults to `false`"
  default     = false
}

variable "storage_profile_disk_driver_enabled" {
  type        = bool
  description = "(Optional) Is the Disk CSI driver enabled? Defaults to `true`"
  default     = true
}

variable "storage_profile_disk_driver_version" {
  type        = string
  description = "(Optional) Disk CSI Driver version to be used. Possible values are `v1` and `v2`. Defaults to `v1`."
  default     = "v1"
}

variable "storage_profile_enabled" {
  description = "Enable storage profile"
  type        = bool
  default     = false
  nullable    = false
}

variable "storage_profile_file_driver_enabled" {
  type        = bool
  description = "(Optional) Is the File CSI driver enabled? Defaults to `true`"
  default     = true
}

variable "storage_profile_snapshot_controller_enabled" {
  type        = bool
  description = "(Optional) Is the Snapshot Controller enabled? Defaults to `true`"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the AKS cluster resources"
  default     = {}
}

variable "ultra_ssd_enabled" {
  type        = bool
  description = "(Optional) Used to specify whether the UltraSSD is enabled in the Default Node Pool. Defaults to false."
  default     = false
}

variable "vnet_subnet_id" {
  type        = string
  description = "(Optional) The ID of a Subnet where the Kubernetes Node Pool should exist. Changing this forces a new resource to be created."
  default     = null
}

variable "web_app_routing" {
  type = object({
    dns_zone_id = string
  })
  description = <<-EOT
  object({
    dns_zone_id = "(Required) Specifies the ID of the DNS Zone in which DNS entries are created for applications deployed to the cluster when Web App Routing is enabled."
  })
EOT
  default     = null
}

variable "workload_identity_enabled" {
  description = "Enable or Disable Workload Identity. Defaults to false."
  type        = bool
  default     = false
}
