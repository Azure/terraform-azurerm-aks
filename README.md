# terraform-azurerm-aks
## Deploys a Kubernetes cluster on AKS with monitoring support through Azure Log Analytics

This Terraform module deploys a Kubernetes cluster on Azure using AKS (Azure Kubernetes Service) and adds support for monitoring with Log Analytics.

## Usage

```hcl
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "2.0.0"

  CLIENT_ID = "your-service-principal-client-appid"
  CLIENT_SECRET = "your-service-principal-client-password"
  prefix = "your-custom-resource-prefix"
}
```

The module supports some outputs that may be used to configure a kubernetes
provider after deploying an AKS cluster.

```hcl
provider "kubernetes" {
  host = "${module.aks.host}"

  client_certificate     = "${base64decode(module.aks.client_certificate)}"
  client_key             = "${base64decode(module.aks.client_key)}"
  cluster_ca_certificate = "${base64decode(module.aks.cluster_ca_certificate)}"
}
```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native (Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install
$ rake build
$ rake e2e
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `mcr.microsoft.com/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-aks .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-aks /bin/bash -c "bundle install && rake full"
```


## Authors

Originally created by [Damien Caro](http://github.com/dcaro) and [Malte Lantin](http://github.com/n01d)

## License

[MIT](LICENSE)

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
