
resource "lxd_instance" "router_oplx" {
  name  = "router-oplx"
  image = "ubuntu:22.04"

  config = {
    "boot.autostart" = true
    "cloud-init.network-config" = templatefile("router-network-config.yaml.tmpl", {
      eth0_ip_address = cidrhost("192.168.2.0/24", 204)
      eth0_prefix     = 24
      eth1_ip_address = cidrhost("10.2.0.0/24", 1)
      eth1_prefix     = 24
      default_gateway = "192.168.2.254"
    })
    "cloud-init.user-data" = templatefile("user-data.yaml.tmpl", {})
  }

  limits = {
    cpu    = 2
    memory = "2GiB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "macvlan"
      parent  = "eno1"
    }
  }

  device {
    name = "eth1"
    type = "nic"
    properties = {
      network = "internal0"
    }
  }

  remote = "optiplex"
}

