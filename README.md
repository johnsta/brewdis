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

## What will you experience
You will:
- Build an existing application locally
- Provision an Azure Spring Cloud service instance
- Deploy the application to Azure
- Open the application

## What you will need

In order to deploy a Java app to cloud, you need 
an Azure subscription. If you do not already have an Azure 
subscription, you can activate your 
[MSDN subscriber benefits](https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/) 
or sign up for a 
[free Azure account]((https://azure.microsoft.com/free/)).

In addition, you will need the following:

| [Azure CLI version 2.0.67 or higher](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest) 
| [Java 11](https://www.azul.com/downloads/azure-only/zulu/?version=java-11-lts&architecture=x86-64-bit&package=jdk) 
| [Maven 3](https://maven.apache.org/download.cgi) 
| [Git](https://git-scm.com/)
|

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

```bash
    az spring-cloud app show --name ${APP_NAME} | grep url
```

Navigate to the URL provided by the previous command to run the brewdis application.
    
![](./media/Brewdis-2020-05-10%2007-05-53.jpg)

## Next Steps

In this quickstart, you've deployed an existing Spring Boot application using Azure CLI.  To learn more about Azure Spring Cloud, 
check out more samples on GitHub: [Azure Spring Cloud Sample](https://github.com/Azure-Samples/Azure-Spring-Cloud).