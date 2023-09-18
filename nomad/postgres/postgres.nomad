job "postgres" {
    datacenter = "dc-1"
    region = "global"
    type = "service"

    group "postgres" {
        count = 1
        
        network {
            port "postgres" {
                to = 5432
            }
        }

        volume "postgres" {
            type            = "host"
            source          = "postgres_data"
            read_only       = false
        }

        service {
            name = "postgres"
            port = "postgres"
            provider = "nomad"
            
            check {
                type     = "tcp"
                port     = "postgres"
                interval = "10s"
                timeout  = "30s"
            }
        }

        task "postgres" {
            driver = "docker"

            config {
                image = "postgres:latest"
                ports = ["postgres"]
            }

            volume_mount {
                volume = "postgres"
                destination = "/var/lib/postgresql/data"
            }

            template {
                env = true
                data = <<EOH
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