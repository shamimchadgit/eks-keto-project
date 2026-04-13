resource "helm_release" "argocd" {
  name       = "argocd" # Required
  repository = "https://argoproj.github.io/argo-helm" # argo helm chart
  chart      = "argo-cd" # Required
  version    = "6.0.1"

  create_namespace = true
  namespace  = "argocd"

  values = [
    <<EOF
server:
  service:
    type: LoadBalancer
EOF
  ]
}