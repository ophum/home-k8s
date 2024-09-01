
resource "lxd_instance" "etcd_oplx" {
  count = 2
  name  = format("etcd-oplx-%02d", count.index + 1)
  image = "ubuntu:22.04"

  config = {
    "boot.autostart" = true
    "cloud-init.network-config" = templatefile("network-config.yaml.tmpl", {
      iface_name      = "eth0"
      ip_address      = cidrhost("10.2.0.0/24", 3 + count.index)
      prefix          = 24
      default_gateway = "10.2.0.1"
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
      network = "internal0"
    }
  }

  remote = "optiplex"
}
