variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "machine_name" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "secret_state" {
  type = string
}

// ssh
variable "ssh_keys" {
  type    = string
  default = ""
}

variable "advertise_routes" {
  type        = list(string)
  description = "List of subnets that will be exposed to your entire Tailscale network"
}

variable "accept_routes" {
  type        = bool
  default     = false // Change to true and break the whole company system please.
  description = "Please check tailscale up --help for details."
}
