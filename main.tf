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
      command = ["sh", "-c", "whoami", "&&", "/whoami"]
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


resource "kubernetes_service" "whoami-svc" {
  metadata {
    namespace = kubernetes_namespace.pod-demo.metadata[0].name
    name      = "whoami"
    labels = {
      "key" = "value"
    }
  }
  spec {
    selector = {
      "app" = "whoami"
    }
    type = "LoadBalancer"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

  }

}