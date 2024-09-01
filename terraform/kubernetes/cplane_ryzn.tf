
resource "lxd_instance" "cplane_ryzn" {
  count = 1
  name  = format("cplane-ryzn-%02d", count.index + 1)
  image = "ubuntu:22.04"
  type  = "virtual-machine"

  config = {
    "boot.autostart" = true
    "cloud-init.network-config" = templatefile("network-config.yaml.tmpl", {
      iface_name      = "enp5s0"
      ip_address      = cidrhost("10.1.0.0/24", 2 + count.index)
      prefix          = 24
      default_gateway = "10.1.0.1"
    })
    "cloud-init.user-data" = templatefile("user-data.yaml.tmpl", {})
  }

  limits = {
    cpu    = 4
    memory = "4GiB"
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      network = "internal0"
    }
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = "default"
      size = "50GiB"
    }
  }

  remote = "ryzen7-5700x"
}
