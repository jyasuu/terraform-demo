resource "kubernetes_namespace" "hpa-demo" {
  metadata {
    name = "hpa-demo"
  }
}


resource "kubernetes_deployment" "hpa_demo" {
  metadata {
    name = "hpa-demo"
    namespace = kubernetes_namespace.hpa-demo.metadata[0].name
    labels = {
      app = "hpa-demo"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hpa-demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "hpa-demo"
        }
      }

      spec {
        container {
          name  = "hpa-demo"
          image = "traefik/whoami"
          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu = "100m"
            }
            limits = {
              cpu = "200m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hpa_demo" {
  metadata {
    namespace = kubernetes_namespace.hpa-demo.metadata[0].name
    name = "hpa-demo"
  }
  spec {
    selector = {
      app = "hpa-demo"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "hpa" {
  metadata {
    namespace = kubernetes_namespace.hpa-demo.metadata[0].name
    name = "hpa-demo-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "hpa-demo"
    }

    min_replicas = 1
    max_replicas = 5

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}