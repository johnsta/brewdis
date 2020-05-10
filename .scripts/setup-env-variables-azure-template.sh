#!/usr/bin/env bash

# ==== Resource Group ====
export SUBSCRIPTION=subscription-id # customize this
export RESOURCE_GROUP=resource-group-name # customize this
export REGION=westeurope

# ==== First Instance ====
export SPRING_CLOUD_SERVICE=azure-spring-cloud-name # customize this
export APP_NAME=retail

# ==== JARS ====
export BREWDIS_JAR=brewdis-api/build/libs/brewdis-api-1.0.0-SNAPSHOT.jar

# ==== REDIS INFO ====
export SPRING_REDIS_HOST=redis-server-host # customize this
export SPRING_REDIS_PASSWORD=redis-password # customize this
export SPRING_REDIS_PORT=10000
export STOMP_HOST=${SPRING_CLOUD_SERVICE}-${APP_NAME}.azuremicroservices.io
#export STOMP_HOST=localhost
export STOMP_PORT=80