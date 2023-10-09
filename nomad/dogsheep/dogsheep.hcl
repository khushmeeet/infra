job "dogsheep" {
  datacenters = ["dc-1"]
  region      = "global"
  type        = "service"

  group "dogsheep" {
    count = 1

    network {
      port "dogsheep" {
        to = 8001
      }
    }

    volume "dogsheep" {
      type      = "host"
      source    = "dogsheep_data"
      read_only = false
    }

    service {
      name     = "dogsheep"
      port     = "dogsheep"
      provider = "nomad"

      check {
        type     = "http"
        path     = "/"
        method   = "GET"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "postgres" {
      driver = "docker"

      config {
        image = "371221980955.dkr.ecr.us-west-1.amazonaws.com/dogsheep:latest"
        ports = ["dogsheep"]
      }

      volume_mount {
        volume      = "dogsheep"
        destination = "/var/lib/dogsheep/data"
      }

      template {
        destination = "secrets.env"
        env         = true
        change_mode = "restart"
        data        = <<EOH
        {{ with nomadVar "nomad/jobs/postgres" }}
        POSTGRES_PASSWORD={{.POSTGRES_PASSWORD}}
        POSTGRES_USER={{.POSTGRES_USER}}
        POSTGRES_DB={{.POSTGRES_DB}}
        {{ end }}
        EOH
      }

      logs {
        max_files = 1
      }
    }
  }
}