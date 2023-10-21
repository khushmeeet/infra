job "pgadmin" {
  datacenters = ["dc-1"]
  region      = "global"
  type        = "service"

  group "pgadmin" {
    count = 1

    network {
      port "pgadmin" {
        to = 5432
      }
    }

    volume "pgadmin" {
      type      = "host"
      source    = "pgadmin_data"
      read_only = false
    }

    service {
      name     = "pgadmin"
      port     = "pgadmin"
      provider = "nomad"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "pgadmin" {
      driver = "docker"

      config {
        image = "dpage/pgadmin4:latest"
        ports = ["pgadmin"]
      }

      volume_mount {
        volume      = "pgadmin"
        destination = "/var/lib/pgadmin/data"
      }

      template {
        destination = "secrets.env"
        env         = true
        change_mode = "restart"
        data        = <<EOH
        {{ with nomadVar "nomad/jobs/pgadmin" }}
        PGADMIN_DEFAULT_EMAIL={{.PGADMIN_DEFAULT_EMAIL}}
        PGADMIN_DEFAULT_PASSWORD={{.PGADMIN_DEFAULT_PASSWORD}}
        {{ end }}
        EOH
      }

      logs {
        max_files = 1
      }
    }
  }
}