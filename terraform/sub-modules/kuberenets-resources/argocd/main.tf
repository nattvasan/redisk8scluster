#############################################
#1. add dns record set  using terraform
#2. Create argocd namespace
#3. deploy argocd using helm chart from package registry
#############################################

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_helm_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "crds.install"
    value = var.install_crds
  }

  depends_on = [
    kubernetes_namespace.argocd,
  ]
}

resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.argocd_apps_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  values = [
    file("../../modules/argocd-values/argocd-app-values/values.yaml")
  ]
  depends_on = [
    helm_release.argocd,
  ]
}

resource "helm_release" "argocd_resources" {
  depends_on = [
    helm_release.argocd,
  ]
  name      = "argocd-resources"
  chart     = "../../modules/argocd-values/argocd-apps/helm"
  namespace = kubernetes_namespace.argocd.id
  version   = "0.1.0"
  values = [
    file("../../modules/argocd-values/argocd-apps/helm/values.yaml")
  ]
}


resource "helm_release" "argocd_rollout" {
  name       = "argocd-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = var.argocd_rollout_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  set {
    name = "dashboard.enabled"
    value = "true"
  }
  set {
    name  = "dashboard.service.type"
    value = "LoadBalancer"
  }
  
  set {
    name  = "installCRDs"
    value = var.install_crds
  }

  set {
    name = "keepCRDs"
    value = var.keep_crds
  }
  depends_on = [
    helm_release.argocd,
  ]
}

resource "helm_release" "argocd_rollout_apps" {
  depends_on = [
    helm_release.argocd,
  ]
  name      = "argocd-resources"
  chart     = "../../modules/argocd-values/argocd-rollout/helm"
  namespace = kubernetes_namespace.argocd.id
  version   = "0.1.0"
  values = [
    file("../../modules/argocd-values/argocd-rollout/helm/values.yaml")
  ]
}
