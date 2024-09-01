resource "lxd_network" "internal0_oplx" {
  name = "internal0"

  config = {
    "ipv4.address" = "none"
    "ipv4.nat"     = "false"
    "ipv6.address" = "none"
    "ipv6.nat"     = "false"
  }

  remote = "optiplex"
}
