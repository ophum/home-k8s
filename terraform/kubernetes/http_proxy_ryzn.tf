
resource "lxd_instance" "http_proxy_ryzn" {
  name  = "http-proxy-ryzn"
  image = "ubuntu:22.04"

  config = {
    "boot.autostart" = true
    "cloud-init.network-config" = templatefile("network-config.yaml.tmpl", {
      iface_name      = "eth0"
      ip_address      = cidrhost("10.1.0.0/24", 254)
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

  remote = "ryzen7-5700x"
}
