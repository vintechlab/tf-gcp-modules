locals {
  advertise_routes = join(",", var.advertise_routes)

  local_script = <<EOS
    set -x
    sudo tailscale up --advertise-routes='${local.advertise_routes}' --accept-routes="${var.accept_routes}"
    sudo tailscale status
  
  EOS

  gcloud_command = <<EOS
    set -x
    yes | gcloud auth login --cred-file=/secrets/.gcp/sva-${var.project}.json
    gcloud compute ssh ubuntu@${var.machine_name} --project=${var.project} --zone=${var.zone} -- sudo bash -xc '${local.local_script}'

  EOS
}

resource "null_resource" "gcloud" {
  triggers = {
    cli_trigger = md5("${local.gcloud_command}")
  }

  provisioner "local-exec" {
    command = local.gcloud_command
  }

  depends_on = [
    google_compute_instance.machine,
  ]
}
