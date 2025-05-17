resource "kubernetes_config_map" "example" {
  metadata {
    name = "example-config"
  }
  data = {
    api_host     = "myhost:443"
    db_host      = "dbhost:5432"
    feature_flag = "enabled"
  }
}

resource "kubernetes_config_map" "from_file" {
  metadata {
    name = "file-config"
  }
  data = {
    "config.json" = jsonencode({
      property = "value"
    })
  }
}


resource "kubernetes_pod" "env_example" {
  metadata {
    name = "pod-env-example"
  }
  spec {
    container {
      name  = "app"
      image = "nginx"
      env {
        name = "API_HOST"
        value_from {
          config_map_key_ref {
            name = kubernetes_config_map.example.metadata[0].name
            key  = "api_host"
          }
        }
      }
      env {
        name = "DB_HOST"
        value_from {
          config_map_key_ref {
            name = kubernetes_config_map.example.metadata[0].name
            key  = "db_host"
          }
        }
      }
    }
  }
}



resource "kubernetes_pod" "volume_example" {
  metadata {
    name = "pod-vol-example"
  }
  spec {
    container {
      name  = "app"
      image = "nginx"
      volume_mount {
        name       = "config-vol"
        mount_path = "/etc/config"
      }
    }
    volume {
      name = "config-vol"
      config_map {
        name = kubernetes_config_map.from_file.metadata[0].name
      }
    }
  }
}



resource "kubernetes_pod" "envfrom_example" {
  metadata {
    name = "pod-envfrom-example"
  }
  spec {
    container {
      name  = "app"
      image = "nginx"

      env_from {
        config_map_ref {
          name = kubernetes_config_map.example.metadata[0].name
        }
      }
    }
  }
}