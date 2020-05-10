---
page_type: sample
languages:
- java
products:
- Azure Spring Cloud
description: "Deploy an existing Java Spring application using Azure Spring Cloud and Redis Enterprise"
urlFragment: "brewdis"

---
# Deploy existing Java Spring Boot app using Azure Spring Cloud and Redis Enterprise 

Azure Spring Cloud enables you to easily run a Spring Boot based microservices application on Azure.

This quickstart shows you how to deploy an existing Java Spring Cloud application to Azure. When you're finished, you can continue to manage the application via the Azure CLI or switch to using the Azure portal.

Following this quickstart, you will learn how to:
- Build an existing application locally
- Provision an Azure Spring Cloud service instance
- Deploy the application to Azure
- Open the application

## Prerequisites

To complete this quickstart:

1. [Install Git](https://git-scm.com/)
2. [Install JDK 11](https://docs.microsoft.com/java/azure/jdk/?view=azure-java-stable)
3. [Install Maven 3.0 or above](https://maven.apache.org/download.cgi)
4. [Install the Azure CLI version 2.0.67 or higher](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
5. [Sign up for an Azure subscription](https://azure.microsoft.com/free/)

## Install the Azure CLI extension

Install the Azure Spring Cloud extension for the Azure CLI using the following command

```bash
    az extension add --name spring-cloud
```

## Clone and build the repo

### Create a new folder and clone the sample app repository to your Azure Cloud account  

```bash
    mkdir source-code
    git clone https://github.com/selvasingh/brewdis
```

### Change directory and build the project

```bash
    cd brewdis
    gradle build
```
This will take a few minutes.

## Provision Azure Spring Cloud service instance using Azure CLI

### Prepare your environment for deployments

Create a bash script with environment variables by making a copy of the supplied template:
```bash
    cp .scripts/setup-env-variables-azure-template.sh .scripts/setup-env-variables-azure.sh
```

Open `.scripts/setup-env-variables-azure.sh` and enter the following information:

```bash
    export SUBSCRIPTION=subscription-id # customize this
    export RESOURCE_GROUP=resource-group-name # customize this
    ...
    export SPRING_CLOUD_SERVICE=azure-spring-cloud-name # customize this
    ...
    export SPRING_REDIS_HOST=redis-server-host # customize this
    export SPRING_REDIS_PASSWORD=redis-password # customize this
```

Then, set the environment:
```bash
    source .scripts/setup-env-variables-azure.sh
```

### Login to the Azure CLI 
Login to the Azure CLI and choose your active subscription. Be sure to choose the active subscription that is whitelisted for Azure Spring Cloud

```bash
    az login
    az account list -o table
    az account set --subscription ${SUBSCRIPTION}
```

### Create Azure Spring Cloud service instance
Prepare a name for your Azure Spring Cloud service.  The name must be between 4 and 32 characters long and can contain only lowercase letters, numbers, and hyphens.  The first character of the service name must be a letter and the last character must be either a letter or a number.

Create a resource group to contain your Azure Spring Cloud service.

```bash
    az group create --name ${RESOURCE_GROUP} \
        --location ${REGION}
```

Open an Azure CLI window and run the following commands to provision an instance of Azure Spring Cloud.

```bash
    az spring-cloud create --name ${SPRING_CLOUD_SERVICE} \
        --resource-group ${RESOURCE_GROUP} \
        --location ${REGION}
```

The service instance will take around five minutes to deploy.

Set your default resource group name and cluster name using the following commands:

```bash
    az configure --defaults \
        group=${RESOURCE_GROUP} \
        location=${REGION} \
        spring-cloud=${SPRING_CLOUD_SERVICE}
```

## Create a microservice application

Create Spring Cloud microservice `retail` app.

```bash
    az spring-cloud app create --name ${APP_NAME} --instance-count 1 --is-public true \
        --memory 2 \
        --runtime-version Java_11 \
        --jvm-options='-Xms2048m -Xmx2048m' \
        --resource-group ${RESOURCE_GROUP} \
        --service ${SPRING_CLOUD_SERVICE}
```

## Deploy application and set environment variables

We need to actually deploy our applications to Azure. Use the following commands to deploy all three applications:

```bash
    az spring-cloud app deploy --name ${APP_NAME} \
        --jar-path ${BREWDIS_JAR} \
        --resource-group ${RESOURCE_GROUP} \
        --service ${SPRING_CLOUD_SERVICE} \
        --env SPRING_REDIS_HOST=${SPRING_REDIS_HOST} \
              SPRING_REDIS_PASSWORD=${SPRING_REDIS_PASSWORD} \
              SPRING_REDIS_PORT=${SPRING_REDIS_PORT} \
              STOMP_HOST=${STOMP_HOST} \
              STOMP_PORT=${STOMP_PORT}
```

```azurecli
az spring-cloud app show --name ${APP_NAME} | grep url
```

3. Navigate to the URL provided by the previous command to run the brewdis application.
    
    ![](./media/Brewdis-2020-05-10%2007-05-53.jpg)

## Next Steps

In this quickstart, you've deployed a Spring Cloud application from the Azure CLI.  To learn more about Azure Spring Cloud, continue to the tutorial on preparing your app for deployment.

More samples are available on GitHub: [Azure Spring Cloud Samples](https://github.com/Azure-Samples/Azure-Spring-Cloud).