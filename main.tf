terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.10.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "time" {}

resource "time_static" "deployed_at" {
}


resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "test" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}


resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_deployment" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = {
      app = "whoami"
    }
  }

  spec {
    replicas = 5

    selector {
      match_labels = {
        app = "whoami"
      }
    }

    template {
      metadata {
        labels = {
          app = "whoami"
        }
        annotations = {
          "deployed-at" = time_static.deployed_at.rfc3339
        }
      }

      spec {
        container {
          name  = "whoami"
          image = "traefik/whoami"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.whoami.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "whoami" {
  metadata {
    name      = "whoami"
    namespace = kubernetes_namespace.demo.metadata[0].name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    }
  }

  spec {
    ingress_class_name = "traefik"

    rule {
      host = var.host

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.whoami.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
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
            name = kubernetes_config_map.simple.metadata[0].name
            key  = "api_host"
          }
        }
      }
      env {
        name = "DB_HOST"
        value_from {
          config_map_key_ref {
            name = kubernetes_config_map.simple.metadata[0].name
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
        name      = "config-vol"
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


resource "kubernetes_config_map" "example" {
  metadata {
    name = "example-config"
  }
  data = {
    api_host = "myhost:443"
    db_host  = "dbhost:5432"
    feature_flag = "enabled"
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
