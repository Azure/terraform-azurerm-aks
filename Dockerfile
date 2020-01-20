# Pull the base image with given version.
ARG BUILD_TERRAFORM_VERSION=0.12.10
FROM mcr.microsoft.com/terraform-test:${BUILD_TERRAFORM_VERSION}

ARG MODULE_NAME="terraform-azurerm-aks"

# Set work directory
RUN mkdir -p /go/src/${MODULE_NAME}
RUN mkdir -p /go/bin
WORKDIR /go/src/${MODULE_NAME}

# Install required go packages using dep ensure
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN /bin/bash -c "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"

COPY . /go/src/${MODULE_NAME}
RUN chmod 744 test.sh