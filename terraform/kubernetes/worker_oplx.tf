
resource "lxd_volume" "worker_oplx_disk1" {
  count        = 1
  name         = format("worker-oplx-%02d-disk1", count.index + 1)
  pool         = "default"
  content_type = "block"

  config = {
    size = "10GiB"
  }

  remote = "optiplex"
}

resource "lxd_instance" "worker_oplx" {
  count = 1
  name  = format("worker-oplx-%02d", count.index + 1)
  image = "ubuntu:22.04"
  type  = "virtual-machine"

  config = {
    "boot.autostart" = true
    "cloud-init.network-config" = templatefile("network-config.yaml.tmpl", {
      iface_name      = "enp5s0"
      ip_address      = cidrhost("10.2.0.0/24", 5 + count.index)
      prefix          = 24
      default_gateway = "10.2.0.1"
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
      size = "30GiB"
    }
  }

  device {
    name = "disk1"
    type = "disk"
    properties = {
      pool   = "default"
      source = lxd_volume.worker_oplx_disk1[count.index].name
    }
  }

  remote = "optiplex"
}

