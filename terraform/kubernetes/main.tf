terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "2.2.0"
    }
  }
}

provider "lxd" {
  remote {
    name = "optiplex"
  }

  remote {
    name = "ryzen7-5700x"
  }
}

# ryzen7-5700x
# gateway: 1
# cplane: 2
# etcd: 3~5
# worker: 6~

# optiplex
# gateway: 1
# cplane: 2
# etcd: 3~4
# worker: 5~
