project = "infra"

app "postgres" {
  build {
    use "docker-pull" {
      image = "postgres"
      tag   = "latest"
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/postgres.hcl")
      config {
        address = "http://axion-1:4646"
      }
    }
  }
}