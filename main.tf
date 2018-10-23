resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kube_version}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.azurek8s_sku}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}

/**
resource "azurerm_storage_account" "acrstorageacc" {
  name                     = "${var.resource_storage_acct}"
  resource_group_name      = "${azurerm_resource_group.k8s.name}"
  location                 = "${azurerm_resource_group.k8s.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
**/
resource "azurerm_container_registry" "acrtest" {
  name                = "${var.azure_container_registry_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  admin_enabled       = true
  sku                 = "Premium"

  /** storage_account_id  = "${azurerm_storage_account.acrstorageacc.id}" **/
}

resource "null_resource" "provision" {
  provisioner "local-exec" {
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.k8s.name} -g ${azurerm_resource_group.k8s.name}"
  }

  provisioner "local-exec" {
    command = "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl;"
  }

  provisioner "local-exec" {
    command = "chmod +x ./kubectl;"
  }

  provisioner "local-exec" {
    command = "mv ./kubectl /usr/local/bin/kubectl;"
  }

  provisioner "local-exec" {
    command = "curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh"
  }

  provisioner "local-exec" {
    command = "chmod 700 get_helm.sh"
  }

  provisioner "local-exec" {
    command = "./get_helm.sh"
  }

  provisioner "local-exec" {
    command = "kubectl config use-context ${azurerm_kubernetes_cluster.k8s.name}"
  }

  /**
                                                                                                                                                                                        provisioner "local-exec" {
                                                                                                                                                                                          command = "echo "$(terraform output kube_config)" > ~/.kube/azurek8s && export KUBECONFIG=~/.kube/azurek8s"
                                                                                                                                                                                        } 
                                                                                                                                                                                      **/
  provisioner "local-exec" {
    command = "helm init --upgrade"
  }

  provisioner "local-exec" {
    command = "kubectl create -f helm-rbac.yaml"
  }

  provisioner "local-exec" {
    command = <<EOF
            sleep 120
      EOF
  }

  provisioner "local-exec" {
    command = "kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=\"${local.username}\""
  }

  /**
                                                                                                                                                                          provisioner "local-exec" {
                                                                                                                                                                            command = "kubectl create -f azure-load-balancer.yaml"
                                                                                                                                                                          }
                                                                                                                                                                  **/
  provisioner "local-exec" {
    command = "helm repo add azure-samples https://azure-samples.github.io/helm-charts/ && helm repo add gitlab https://charts.gitlab.io/ && helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/ && helm repo add bitnami https://charts.bitnami.com/bitnami"
  }

  provisioner "local-exec" {
    command = "helm repo update"
  }

  provisioner "local-exec" {
    command = "helm install stable/nginx-ingress --namespace kube-system --set rbac.create=false"
  }

  provisioner "local-exec" {
    command = "helm install azure-samples/aks-helloworld"
  }

  provisioner "local-exec" {
    command = "helm install stable/cert-manager  --set ingressShim.defaultIssuerName=letsencrypt-staging  --set ingressShim.defaultIssuerKind=ClusterIssuer --set rbac.create=false  --set serviceAccount.create=false"
  }

  provisioner "local-exec" {
    command = "wget -qO- https://azuredraft.blob.core.windows.net/draft/draft-v0.15.0-linux-amd64.tar.gz | tar xvz"
  }

  provisioner "local-exec" {
    command = "cp linux-amd64/draft /usr/local/bin/draft"
  }

  provisioner "local-exec" {
    command = "draft init"
  }

  provisioner "local-exec" {
    command = "draft config set registry ${azurerm_container_registry.acrtest.name}.azurecr.io"
  }

  provisioner "local-exec" {
    command = "helm repo add brigade https://azure.github.io/brigade"
  }

  provisioner "local-exec" {
    command = "helm install brigade/brigade --name brigade-server"
  }

  provisioner "local-exec" {
    command = <<EOF
            if [ "${var.helm_install_jenkins}" = "true" ]; then
                helm install -n ${azurerm_kubernetes_cluster.k8s.name} stable/jenkins -f jenkins-values.yaml --version 0.16.18
            else
                echo ${var.helm_install_jenkins}
            fi
      EOF

    timeouts {
      create = "20m"
      delete = "20m"
    }
  }

  depends_on = ["azurerm_kubernetes_cluster.k8s"]
}

resource "null_resource" "kube-prometheus-clone" {
  provisioner "local-exec" {
    command = "git clone https://github.com/coreos/prometheus-operator.git"
  }
}

resource "null_resource" "kube-prometheus-package" {
  provisioner "local-exec" {
    command = "cd prometheus-operator && kubectl apply -f bundle.yaml"
  }

  provisioner "local-exec" {
    command = "cd prometheus-operator && mkdir -p helm/kube-prometheus/charts"
  }

  provisioner "local-exec" {
    command = "cd prometheus-operator && helm package -d helm/kube-prometheus/charts helm/alertmanager helm/grafana helm/prometheus  helm/exporter-kube-dns helm/exporter-kube-scheduler helm/exporter-kubelets helm/exporter-node helm/exporter-kube-controller-manager helm/exporter-kube-etcd helm/exporter-kube-state helm/exporter-coredns helm/exporter-kubernetes"
  }

  depends_on = ["azurerm_kubernetes_cluster.k8s", "null_resource.provision", "null_resource.kube-prometheus-clone"]
}

resource "null_resource" "kube-racecheck" {
  /**
                                      Kubernetes Race condition check for older than 1.11.* version- https://github.com/kubernetes/kubernetes/issues/62725
                                      This is specific when CRD status is complete but API Server is not actually available. Kicks in for kube-prometheus for older than 11.1.* k8s version
                                      **/
  provisioner "local-exec" {
    command = <<EOF
    kube_major=$(echo ${var.kube_version}|cut -d'.' -f 1-2)
    if  [ "$kube_major" = "1.11" ] || [ "$kube_major" = "1.10" ] || [ "$kube_major" = "1.9" ]; then
        #if [ "$kube_major" = "1.10" ] || [ "$kube_major" = "1.9" ]; then
           sleep 180
        #else
          echo ${var.kube_version}
        #fi
    else
         echo ${var.kube_version}
    fi    
EOF
  }

  depends_on = ["azurerm_kubernetes_cluster.k8s", "null_resource.provision", "null_resource.kube-prometheus-clone", "null_resource.kube-prometheus-package"]
}

resource "null_resource" "kube-prometheus-install" {
  provisioner "local-exec" {
    command = "cd prometheus-operator && helm install helm/kube-prometheus --name kube-prometheus --wait --namespace monitoring --set global.rbacEnable=false"

    timeouts {
      create = "20m"
      delete = "20m"
    }
  }

  depends_on = ["azurerm_kubernetes_cluster.k8s", "null_resource.provision", "null_resource.kube-prometheus-clone", "null_resource.kube-prometheus-package", "null_resource.kube-racecheck"]
}

resource "null_resource" "post-kube-prometheus" {
  provisioner "local-exec" {
    command = <<EOF
            if [ "${var.patch_svc_lbr_external_ip}" = "true" ]; then
                kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"LoadBalancer"}}' --namespace kube-system && kubectl patch svc aks-helloworld -p '{"spec":{"type":"LoadBalancer"}}' && kubectl patch svc kube-prometheus-grafana -p '{"spec":{"type":"LoadBalancer"}}' --namespace monitoring
            else
                echo ${var.patch_svc_lbr_external_ip}
            fi
      EOF
  }

  provisioner "local-exec" {
    command = <<EOF
    skuseries=$(echo ${var.azurek8s_sku}|cut -d'_' -f 2|cut -c1-2)
    kube_major=$(echo ${var.kube_version}|cut -d'.' -f 1-2)
    if { [ "$kube_major" = "1.11" ] || [ "$kube_major" = "1.10" ]; } && [ "$skuseries" = "NC" ]; then
        if [ "$kube_major" = "1.10" ]; then
          sed -i.bak -e '25d' nvidia-device-plugin-ds.yaml && sed -i '25i\ \ \ \ \ \ - image: nvidia/k8s-device-plugin:1.10' nvidia-device-plugin-ds.yaml && kubectl apply -f nvidia-device-plugin-ds.yaml --namespace kube-system
        else
          kubectl apply -f nvidia-device-plugin-ds.yaml --namespace kube-system
        fi
    else
         echo ${var.azurek8s_sku}
    fi
  EOF
  }
  provisioner "local-exec" {
    command = <<EOF
                if [ "${var.install_suitecrm}" = "true" ]; then
                    kubectl create namespace sugarcrm && helm install --name sugarcrm-dev --set allowEmptyPassword=false,mariadb.rootUser.password=secretpassword,mariadb.db.password=secretpassword stable/suitecrm --namespace sugarcrm && sleep 240 && export APP_HOST=$(kubectl get svc --namespace sugarcrm sugarcrm-dev-suitecrm --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}") && export APP_PASSWORD=$(kubectl get secret --namespace sugarcrm sugarcrm-dev-suitecrm -o jsonpath="{.data.suitecrm-password}" | base64 -d) && export APP_DATABASE_PASSWORD=$(kubectl get secret --namespace sugarcrm sugarcrm-dev-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d) && helm upgrade sugarcrm-dev stable/suitecrm --set suitecrmHost=$APP_HOST,suitecrmPassword=$APP_PASSWORD,mariadb.db.password=$APP_DATABASE_PASSWORD
                else
                    echo ${var.install_suitecrm}
                fi
          EOF
  }
  
  depends_on = ["azurerm_kubernetes_cluster.k8s", "null_resource.provision", "null_resource.kube-prometheus-clone", "null_resource.kube-prometheus-package", "null_resource.kube-racecheck", "null_resource.kube-prometheus-install"]
}

/**
resource "azurerm_storage_account" "aci-sa" {
  name                     = "${var.resource_storage_acct}"
  resource_group_name      = "${azurerm_resource_group.k8s.name}"
  location                 = "${azurerm_resource_group.k8s.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "aci-share" {
  name = "${var.resource_aci-dev-share}"

  resource_group_name  = "${azurerm_resource_group.k8s.name}"
  storage_account_name = "${azurerm_storage_account.aci-sa.name}"

  quota = 50
}

resource "azurerm_container_group" "aci-helloworld" {
  name                = "${var.resource_aci-hw}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  ip_address_type     = "public"
  dns_name_label      = "${var.resource_dns_aci-label}"
  os_type             = "linux"

  container {
    name   = "hw"
    image  = "seanmckenna/aci-hellofiles"
    cpu    = "0.5"
    memory = "1.5"
    port   = "80"

    environment_variables {
      "NODE_ENV" = "dev"
    }

    command = "/bin/bash -c '/path to/myscript.sh'"

    volume {
      name       = "logs"
      mount_path = "/aci/logs"
      read_only  = false
      share_name = "${var.resource_aci-dev-share}"

      storage_account_name = "${azurerm_storage_account.aci-sa.name}"
      storage_account_key  = "${azurerm_storage_account.aci-sa.primary_access_key}"
    }
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags {
    environment = "Dev"
  }
}
**/

