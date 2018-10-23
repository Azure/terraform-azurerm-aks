<img src="https://camo.githubusercontent.com/deb5e59540f33524f80ca6e781894672b9b152b0/68747470733a2f2f617a757265636f6d63646e2e617a757265656467652e6e65742f6376742d346261316163363334313062623262626539663163326137626564633537383934626265393735343330396439643338306465656463646637383530303437652f696d616765732f7368617265642f736f6369616c2f617a7572652d69636f6e2d323530783235302e706e67" width="50" height="50" /> <img src="https://azurecomcdn.azureedge.net/cvt-c18d17f36d00dc6637f795280fe675826238c2c9ed2c998cfa9460ed4a2f9115/images/page/services/kubernetes-service/scale-and-run.svg" width="100" height="100" /> <img src="https://dd3hq3hnmbuiz.cloudfront.net/images/Terraform-Background.jpg" width="100" height="50" /> <img src="https://carlos.mendible.com/assets/img/posts/aks.png" width="100" height="50" />   <img src="https://azure.microsoft.com/svghandler/container-registry/?width=600&height=315" width="90" height="50" /> <a href="https://helm.sh/"><img src="http://www.razibinrais.com/wp-content/uploads/2018/07/helm.png" width="50" height="50" /></a> <a href="https://draft.sh/"><img src="https://ordina-jworks.github.io/img/2018-02-12-Azure-Draft/draft-logo.png" width="110" height="50" /></a> <a href="https://brigade.sh/"><img src="https://brigade.sh/assets/images/brigade.png" width="110" height="50" /></a>

This repository is actively maintained @ https://github.com/azure/terraform-azurerm-aks
  
Table of Contents (Azure Kubernetes Service with Terraform)
=================

1. [Create ServicePrincipal and Subscription ID](#create-serviceprincipal-and-subscription-id)
2. [Install terraform locally](#install-terraform-locally)
3. [Automatic provisioning](#automatic-provisioning)
   * [All in one with docker azure-cli-python](#all-in-one-with-docker-azure-cli-python)
      * [kubeconfig](#kubeconfig)
      * [Sanity](#sanity)
      * [Jenkins master](#jenkins-master)
      * [Tiller Server with Draft and Brigade Server](#tiller-server-with-draft-and-brigade-server)
      * [kube-prometheus-grafana](#kube-prometheus-grafana)
      * [Tesla K80 GK210 check and sanity for NC Series via k8s nvidia device plugin in cluster](#tesla-k80-gk210-check-and-sanity-for-nc-series-via-k8s-nvidia-device-plugin-in-cluster)
4. [License](#license)
5. [Terraform graph](#terraform-graph)
6. [Code of conduct](#code-of-conduct)
7. [Todo](#todo)
8. [Manual stepped provisioning](#manual-stepped-provisioning)
   * [ Run Azure cli container and copy terraform binary along with id_rsa to it](#run-azure-cli-container-and-copy-terraform-binary-along-with-id_rsa-to-it)
   * [Clone this repo in the azure-cli-python container](#clone-this-repo-in-the-azure-cli-python-container)
   * [Fill in the variables.tf with default values](#fill-in-the-variables-file-with-default-values)
   * [Terraform for aks](#terraform-for-aks)
9. [Reporting bugs](#reporting-bugs)
10. [Patches and pull requests](#patches-and-pull-requests)

[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors)

Have Fun checking a 4x speed AKS creation via asciinema - 3 node cluster with required jenkins plugins, tiller, ingress controllers, brigade, prometheus-grafana, takes around 20 minutes on Azure.

<a href="https://asciinema.org/a/196121?autoplay=1"><img src="https://asciinema.org/a/196121.png" width="836"/></a>


### Create ServicePrincipal and Subscription ID
`docker run -ti docker4x/create-sp-azure aksadmin`

`Your access credentials ==================================================`

`AD ServicePrincipal App ID:       xxxxxx `

`AD ServicePrincipal App Secret:   xxxxxx `

`AD ServicePrincipal Tenant ID:   xxxxxx`

### Install terraform locally
`wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip -O temp.zip; unzip temp.zip; rm temp.zip ;sudo cp terraform /usr/local/bin`
### Automatic provisioning 
#### All in one with docker azure-cli-python and terraform
> **Some of the terraform local-exec provisioning installs tools like Kubectl and moves the binary and hence containerized usage of this repo is reccomended with the pre-requisites.**

Please note **docker** should be installed with **terraform** binary and your **id_rsa.pub** present in directory of this cloned repo for running the following. 

>**Terraform locally installed has binary in non-root `/usr/local/bin`**

>Docker usage in deploying is only for  the az-cli-python container usage without installing locally.

Create a new cluster -Please note **docker** should be installed with **terraform** binary and your **id_rsa.pub** present in directory for running the following.

**`wget https://raw.githubusercontent.com/azure/terraform-azurerm-aks/master/create_cluster.sh && chmod +x create_cluster.sh && ./create_cluster.sh`**

Terraform will now prompt for the 12 variables as below in sequence:

1. agent_count 
2. azurek8s_sku
3. azure_container_registry_name 
4. client_id
5. client_secret
6. cluster_name
7. dns_prefix
8. helm_install_jenkins
9. kube_version
10. location
11. patch_svc_lbr_external_ip
12. resource_group_name

Expected Values and conventions for the 12 variables are as follows : 

1. var.agent_count
    
    Number of Cluster Agent Nodes (GPU Quota is defaulted to only 1 Standard_NC6 per subscription) - Please view https://docs.microsoft.com/en-us/azure/aks/faq#are-security-updates-applied-to-aks-agent-nodes

    Enter a value: `<<agent_count are the number of "agents" - 1 for a GPU (or more if you have quota or 3 or 5 or 7>>`

2. var.azure_container_registry_name
    
    Please input the ACR name to create in the same Resource Group

    Enter a value: `<<azure_container_registry_name as "alphanumeric" as "<<org>>aks<<yournameorBU>>">>`

3. var.azurek8s_sku

    Sku of Cluster node- Recommend -Standard_F4s_v2- for normal and -Standard_NC6- for GPU (GPU Quota is defaulted to only 1 per subscription) Please view Azure Linux VM Sizes at https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes

    Enter a value: `Standard_F4s_v2`

4. var.client_id
    
    Please input the Azure Application ID known as client_id

    Enter a value: `<<client_id which is the sp client Id>>`

5. var.client_secret
    Please input the Azure client secret for the Azure Application ID known as client_id

    Enter a value: `<<client_secret which is the secret for the above as created in pre-req>>`

6. var.cluster_name
    
    Please input the k8s cluster name to create

    Enter a value: `<<cluster_name as "<<org>>aks<<yournameorBU>>"`

7. var.dns_prefix
    
    Please input the DNS prefix to create

    Enter a value: `<<dns_prefix as "<<org>>aks<<yournameorBU>>"`

8. var.helm_install_jenkins
    
    Please input whether to install Jenkins by default- either **true** or **false**

    Enter a value: `<<true/false>>`

9. var.kube_version
    
    Please input the k8s version - 1.10.6 or 1.11.1 or 1.11.2 or 1.11.3 (eastus)

    Enter a value: `1.11.3`

10. var.location
    
    Please input the Azure region for deployment - for e.g: westeurope or eastus 

    Enter a value: `eastus`

11. var.patch_svc_lbr_external_ip

    Please input to patch grafana, kubernetes-dashboard service via LBR Ingress External IP- either **true** or **false**

    Enter a value: `<<true/false>>`

12. var.resource_group_name
    
    Please input a new Azure Resource group name 

    Enter a value: `<<Azure Resource group for aks service as "<<org>>aks<<yournameorBU>>"`


> kube_version may vary from 1.9.x to 1.11.3 through 10.3.6- Please note 1.11.3 is ~~only~~ now available in ~~the American~~ all regions. Latest is 1.11.3 available in eastus and westeurope. Please view Azure Service Availability for [AKS in Regions](https://azure.microsoft.com/en-us/global-infrastructure/services/) and also via `az aks get-versions --location <<locationname>>`

> The DNSPrefix must contain between 3 and 45 characters and can contain only letters, numbers, and hyphens.  It must start with a letter and must end with a letter or a number. 

> Only alpha numeric characters only are allowed in azure_container_registry_name.

>Expected account_tier for storage to be one of **Standard** **Premium** with max **GRS** and **not RAGRS**. `storage_account_id` can only be specified for a **Classic (unmanaged)** Sku of Azure Container Registry. This does not support web hooks. Default is **Premium** Sku of Azure Container Registry.
  

#### KUBECONFIG
`echo "$(terraform output kube_config)" > ~/.kube/azurek8s`

Also one can echo and copy content to local kubectl config.

`export KUBECONFIG=~/.kube/azurek8s`

#### Sanity
`kubectl get nodes`

`kubectl proxy`

Dashboard available at `http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy/#!/overview?namespace=default`.

or if proxied from a server can be online as follows:

`kubectl proxy --address 0.0.0.0 --accept-hosts .* &`

#### Jenkins Master

After Cluster creation, all you need to do is perform "kubectl get svc" to get url for jenkins and obtain jenkins password as follows- preferably from within the azure-cli-python container bash prompt post cluster creation:

`printf $(kubectl get secret --namespace default hclaks-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 -d);echo`


#### Tiller Server with Draft and Brigade Server

Auto Provisioned.

One can also use draft with the Container Registry and use helm to install any chart as follows:

<br/> <img src="https://cdn-images-1.medium.com/max/1600/1*Nsme583Ut1TY6IDZjKl27w.png" width="450" height="225" /> <br/> <img src="https://cdn-images-1.medium.com/max/1600/1*kV56ClDz_rrMg5wT4lpQ5Q.png" width="450" height="225" />

#### kube-prometheus-grafana
Provisioned by master `main.tf local-exe provisioner` via `git clone https://github.com/coreos/prometheus-operator.git` **without RBAC**- `global.rbacEnable=false` and **without `prometheus-operator`** .


Dashboard available post port forward via:

`kubectl get pods --namespace monitoring`


`kubectl get pods kube-prometheus-grafana-6f8554f575-bln7x --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}' --namespace monitoring`


`kubectl port-forward kube-prometheus-grafana-6f8554f575-bln7x  3000:3000 --namespace monitoring & `

User/Password for grafana (generally `admin/admin`)

`kubectl get secret --namespace monitoring kube-prometheus-grafana -o jsonpath="{.data.password}" | base64 --d ; echo`

`kubectl get secret --namespace monitoring kube-prometheus-grafana -o jsonpath="{.data.user}" | base64 --d ; echo`

#### Tesla K80 GK210 check and sanity for NC Series via k8s nvidia device plugin in cluster
`kubectl get nodes|awk '{print $1}'|sed 1d|xargs kubectl describe node|grep nvidia`

`Labels:             accelerator=nvidia
  kube-system                nvidia-device-plugin-bj4hx                                       0 (0%)        0 (0%)      0 (0%)           0 (0%)
  `

For benchmarking with multi GPUs - min. 8 by default with 1 replica please use the following repo, clone and change number of GPU required to run the benchmarking mpi job.
https://github.com/kubeflow/mpi-operator


### License
  * Please see the [LICENSE file](https://github.com/azure/terraform-azurerm-aks/blob/master/LICENSE) for licensing information.
### Code of Conduct
  * Please see the [Code of Conduct](https://github.com/azure/terraform-azurerm-aks/blob/master/CODE_OF_CONDUCT.md)
### Terraform Graph
Please generate dot format (Graphviz) terraform configuration graphs for visual representation of the repo.

`terraform graph | dot -Tsvg > graph.svg`

Attached is the present master Branch graph. (Click to enlarge)

  <img src="https://raw.githubusercontent.com/azure/terraform-azurerm-aks/master/graph.png"/>
  
Also, one can use [Blast Radius](https://github.com/28mm/blast-radius) on live initialized terraform project to view graph.
Please shoot in dockerized format:

`docker ps -a|grep blast-radius|awk '{print $1}'|xargs docker kill && rm -rf aks-terraform && git clone https://github.com/azure/terraform-azurerm-aks && cd aks-terraform && terraform init && docker run --cap-add=SYS_ADMIN -dit --rm -p 5000:5000 -v $(pwd):/workdir:ro 28mm/blast-radius && cd ../`

 A live example is [here](http://buildservers.westeurope.cloudapp.azure.com:5000/) for this project. A picture is attached below on master. [Blast Radius](https://github.com/28mm/blast-radius) is a pip3 install.

<img src="https://raw.githubusercontent.com/azure/terraform-azurerm-aks/master/blast-radius.jpg">

### Todo

* **RBAC**
* **Service Mesh**
* **Kashti**

### Manual stepped provisioning
#### Run Azure cli container and copy terraform binary along with id_rsa to it

`docker run -dti --name=azure-cli-python --restart=always azuresdk/azure-cli-python && docker cp terraform azure-cli-python:/ && docker cp ~/.ssh/id_rsa azure-cli-python:/ && docker exec -ti azure-cli-python bash -c "az login && bash"`

#### Clone this repo in the azure-cli-python container
`git clone https://github.com/azure/terraform-azurerm-aks`

`curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl;`

Optionally, you can also install kubectl locally. This repo installs kubectl in the azure-cli-python container.


`chmod +x ./kubectl;`

`mv ./kubectl /usr/local/bin/kubectl;`

`mv /id_rsa.pub /aks-terraform;`

#### Fill in the variables file with default values

#### Terraform for aks
`mv ~/terraform aks-terraform/`
`cd aks-terraform`
`terraform init`

`terraform plan -out run.plan`

`terraform apply "run.plan"`


### Reporting bugs

Please report bugs  by opening an issue in the [GitHub Issue Tracker](https://github.com/azure/terraform-azurerm-aks/issues).
Bugs have auto template defined. Please view it [here](https://github.com/azure/terraform-azurerm-aks/blob/master/.github/ISSUE_TEMPLATE/bug_report.md)

### Patches and pull requests

Patches can be submitted as GitHub pull requests. If using GitHub please make sure your branch applies to the current master as a 'fast forward' merge (i.e. without creating a merge commit). Use the `git rebase` command to update your branch to the current master if necessary.

## Contributors
:sparkles: Recognize all contributors, not just the ones who push code :sparkles:

Thanks goes to these wonderful people :

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
| [<img src="https://avatars1.githubusercontent.com/u/3009423?v=4" width="100px;"/><br /><sub><b>anishnagaraj</b></sub>](https://github.com/anishnagaraj)<br /> | [<img src="https://avatars1.githubusercontent.com/u/18348296?v=4" width="100px;"/><br /><sub><b>Ranjith</b></sub>](https://github.com/ranparam01)<br />  | [<img src="https://avatars2.githubusercontent.com/u/13200390?v=4" width="100px;"/><br /><sub><b>cvakumark</b></sub>](https://github.com/cvakumark)<br /> | [<img src="https://avatars0.githubusercontent.com/u/16762700?v=4" width="100px;"/><br /><sub><b>Dwai Banerjee</b></sub>](https://github.com/dwaiba)<br /> |
| :---: | :---: | :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!

