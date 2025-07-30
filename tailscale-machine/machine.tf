data "google_compute_network" "network" {
  name = var.network
}

data "google_compute_subnetwork" "subnetwork" {
  name = var.subnetwork
}

data "google_secret_manager_secret_version" "tailscaled_state" {
  secret = var.secret_state
}

resource "google_compute_instance" "machine" {
  project = var.project
  zone    = var.zone
  name    = var.machine_name

  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = var.ssh_keys
  }

  metadata_startup_script = templatefile("data/startup_script.sh", {
    machine_name     = var.machine_name,
    tailscaled_state = data.google_secret_manager_secret_version.tailscaled_state.secret_data,
  })
}
