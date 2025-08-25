resource "kubernetes_namespace_v1" "example" {
  metadata {
    name = "example"
  }

  depends_on = [module.aks]
}

resource "kubernetes_pod" "aspnet_app" {
  #checkov:skip=CKV_K8S_8:We don't need readiness probe for this simple example.
  #checkov:skip=CKV_K8S_9:We don't need readiness probe for this simple example.
  #checkov:skip=CKV_K8S_22:readOnlyRootFilesystem would block our pod from working
  #checkov:skip=CKV_K8S_28:capabilities would block our pod from working
  metadata {
    labels = {
      app = "aspnetapp"
    }
    name      = "aspnetapp"
    namespace = kubernetes_namespace_v1.example.metadata[0].name
  }
  spec {
    container {
      name              = "aspnetapp-image"
      image             = "mcr.microsoft.com/dotnet/samples@sha256:7070894cc10d2b1e68e72057cca22040c5984cfae2ec3e079e34cf0a4da7fcea"
      image_pull_policy = "Always"

      port {
        container_port = 80
        protocol       = "TCP"
      }
      resources {
        limits = {
          cpu    = "250m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }
      security_context {}
    }
  }
}

resource "kubernetes_service" "svc" {
  metadata {
    name      = "aspnetapp"
    namespace = kubernetes_namespace_v1.example.metadata[0].name
  }
  spec {
    selector = {
      app = "aspnetapp"
    }

    port {
      port        = 80
      protocol    = "TCP"
      target_port = 80
    }
  }
}

resource "kubernetes_ingress_v1" "ing" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class" : "azure/application-gateway"
    }
    name      = "aspnetapp"
    namespace = kubernetes_namespace_v1.example.metadata[0].name
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Exact"

          backend {
            service {
              name = "aspnetapp"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    module.aks,
  ]
}

resource "time_sleep" "wait_for_ingress" {
  create_duration = "15m"

  depends_on = [kubernetes_ingress_v1.ing]
}

data "kubernetes_ingress_v1" "ing" {
  metadata {
    name      = "aspnetapp"
    namespace = kubernetes_namespace_v1.example.metadata[0].name
  }

  depends_on = [time_sleep.wait_for_ingress]
}