resource "kubernetes_namespace" "pod-demo" {
  metadata {
    name = "pod-demo"
  }
}

resource "kubernetes_pod" "whoami" {
  metadata {
    namespace = kubernetes_namespace.pod-demo.metadata[0].name
    name      = "whoami"
    labels = {
      app = "whoami"
    }

  }
  spec {
    restart_policy = "OnFailure"
    container {
      name    = "whoami1"
      image   = "traefik/whoami"
      command = ["sh", "-c", "whoami"]
      port {
        container_port = 80
      }
      port {
        container_port = 443
      }
    }
    container {
      name  = "whoami2"
      image = "traefik/whoami"
      port {
        container_port = 80
      }
      port {
        container_port = 443
      }

    }
  }
}