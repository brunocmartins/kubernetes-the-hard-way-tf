module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  count = var.enable_vpc ? 1 : 0

  project_id   = var.project_id
  network_name = "kubernetes-the-hard-way"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "kubernetes"
      subnet_ip     = "10.240.0.0/24"
      subnet_region = var.region
    }
  ]

  firewall_rules = [
    {
      name      = "kubernetes-the-hard-way-allow-internal"
      direction = "INGRESS"
      priority  = 1000
      ranges = [
        "10.240.0.0/24",
        "10.200.0.0/16",
      ]
      allow = [
        {
          protocol = "tcp"
          ports    = []
        },
        {
          protocol = "udp"
          ports    = []
        },
        {
          protocol = "icmp"
          ports    = []
        },
      ]
    },
    {
      name      = "kubernetes-the-hard-way-allow-external"
      direction = "INGRESS"
      priority  = 1000
      ranges = [
        "0.0.0.0/0",
      ]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "6443"]
        },
        {
          protocol = "icmp"
          ports    = []
        },
      ]
    }
  ]
}
