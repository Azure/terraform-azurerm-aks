output "ingress_endpoint" {
  depends_on = [time_sleep.wait_for_ingress]
  value      = "http://${data.kubernetes_ingress_v1.ing.status[0].load_balancer[0].ingress[0].ip}"
}
