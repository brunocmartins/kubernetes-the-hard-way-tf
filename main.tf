resource "google_compute_address" "kubernetes" {
  count = var.step_3 ? 1 : 0

  name   = "kubernetes-the-hard-way"
  region = data.google_client_config.current.region
}

module "vpc" {
  source = "./modules/vpc"

  enable_vpc = var.step_3
  project_id = data.google_client_config.current.project
  region     = data.google_client_config.current.region
}

resource "google_compute_instance" "kubernetes_controllers" {
  count = var.step_3 ? 3 : 0

  name = "controller-${count.index}"
  machine_type = "e2-standard-2"
  zone = data.google_client_config.current.zone
  can_ip_forward = true

  tags = [
    "kubernetes-the-hard-way",
    "controller",
  ]

  boot_disk {
    initialize_params {
      size = 200
      image = "ubuntu-os-cloud/ubuntu-2004-lts" # image-project/image-family
    }
  }

  network_interface {
    subnetwork = "kubernetes"
    network_ip = "10.240.0.1${count.index}"

    access_config {
      network_tier = "PREMIUM"
    }
  }

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
}

resource "google_compute_instance" "kubernetes_workers" {
  count = var.step_3 ? 3 : 0

  name = "worker-${count.index}"
  machine_type = "e2-standard-2"
  zone = data.google_client_config.current.zone
  can_ip_forward = true

  tags = [
    "kubernetes-the-hard-way",
    "worker",
  ]

  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }

  boot_disk {
    initialize_params {
      size = 200
      image = "ubuntu-os-cloud/ubuntu-2004-lts" # image-project/image-family
    }
  }

  network_interface {
    subnetwork = "kubernetes"
    network_ip = "10.240.0.2${count.index}"

    access_config {
      network_tier = "PREMIUM"
    }
  }

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
}
