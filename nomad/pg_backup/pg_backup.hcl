job "pg_backup" {
  datacenter = "dc-1"
  region = "global"
  type = "service"

  group "pg_backup" {
    count = 1

    service {
      name = "pg_backup"
      provider = "nomad"
    }

    task "pg_backup" {
      driver = "docker"

      config {
        image = "371221980955.dkr.ecr.us-west-1.amazonaws.com/pg_backup:latest"
      }

      template {
        env = true
        data = <<EOH
        {{ with nomadVar "nomad/jobs/pg_backup" }}
        POSTGRES_HOST={{.POSTGRES_HOST}}
        POSTGRES_PASSWORD={{.POSTGRES_PASSWORD}}
        POSTGRES_USER={{.POSTGRES_USER}}
        POSTGRES_DB={{.POSTGRES_DB}}
        AWS_ACCESS_KEY_ID={{.AWS_ACCESS_KEY_ID}}
        AWS_SECRET_ACCESS_KEY={{.AWS_SECRET_ACCESS_KEY}}
        {{ end }}
        EOH
      }

      logs {
        max_files = 1
      }
    }
  }
}