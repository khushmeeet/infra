datacenter = "dc-1"
data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

advertise {
  http = "{{ GetInterfaceIP `tailscale0` }}"
  rpc  = "{{ GetInterfaceIP `tailscale0` }}"
  serf = "{{ GetInterfaceIP `tailscale0` }}"
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = [ "127.0.0.1" ]

  host_volume "postgres_data" {
    path      = "/var/lib/nomad/postgresql/"
    read_only = false
  }
}

ui {
  enabled = true
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}
