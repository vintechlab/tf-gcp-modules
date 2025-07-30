variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "network_name" {
  type        = string
  description = "Network name"
}

variable "psc_forwarding_rule" {
  type = list(object({
    name                    = string
    region                  = optional(string)
    target                  = optional(string)
    network                 = optional(string)
    ip_name                 = optional(string)
    subnetwork              = optional(string)
    load_balancing_scheme   = optional(string, "")
    allow_psc_global_access = optional(bool, true)
    labels                  = optional(map(string), {})
  }))

  default = []

  description = "list of forwarding rule to be used with psc endpoint - consumer side - and creates one static ip address"
}
