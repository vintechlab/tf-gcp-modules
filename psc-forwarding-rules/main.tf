resource "google_compute_forwarding_rule" "psc_forwarding_rule" {
  for_each                = { for rule in var.psc_forwarding_rule : rule.name => rule }
  name                    = each.value.name
  region                  = each.value.region
  load_balancing_scheme   = each.value.load_balancing_scheme
  target                  = each.value.target
  network                 = var.network_name
  ip_address              = module.psc_forwarding_rule_ips[each.value.name].self_links[0]
  allow_psc_global_access = each.value.allow_psc_global_access
}

module "psc_forwarding_rule_ips" {
  for_each     = { for rule in var.psc_forwarding_rule : rule.name => rule }
  source       = "terraform-google-modules/address/google"
  version      = "4.1.0"
  project_id   = var.gcp_project
  region       = each.value.region
  names        = [each.value.name]
  subnetwork   = each.value.subnetwork
  address_type = "INTERNAL"
}
