#!/usr/bin/env bash

# Exit script if any command returns non-zero
set -e

if [ "$#" -ne 6 ]; then
  echo "ERROR: Incorrect number of arguments, 8 required"
  echo "Usage:"
  echo "$0 <pullSecret> <ENVIRONMENT> <NAMESPACE> <IMAGE_NAME> <IMAGE_VERSION> <DOCKER_REPO> <ACR> <REPLICAS>"
  exit 1
fi

PULL_SECRET=$1
ENVIRONMENT=$2
NAMESPACE=$3
#IMAGE_NAME=$4
IMAGE_VERSION=$4
#DOCKER_REPO=$6
ACR=$5
REPLICAS=$6

DEPLOYMENT_NAME="spring-demo-api-${ENVIRONMENT}-deployment"
DEPLOYMENT_POD="spring-demo-api-${ENVIRONMENT}-pod"
DEPLOYMENT_SERVICE="spring-demo-api-${ENVIRONMENT}-service"
HTTPS_CONTAINER_PORT=8443
HTTP_CONTAINER_PORT=8080

# Prints all executed commands to terminal
set -x

echo "apiVersion: v1
kind: Service
metadata:
  name: ${DEPLOYMENT_SERVICE}
  annotations:
    service.beta.kubernetes.io/azure-dns-label-name: pqa-prod-${ENVIRONMENT}
  namespace: ${NAMESPACE}
spec:
  type: LoadBalancer
  selector:
    app: spring-boot-api-${ENVIRONMENT}
  ports:
    - protocol: TCP
      port: 8443
      targetPort: ${HTTPS_CONTAINER_PORT}
      name: https
    - protocol: TCP
      port: 8080
      targetPort: ${HTTP_CONTAINER_PORT}
      name: http
" > service.yaml

# Create a service to attach to the deployment
kubectl apply -f service.yaml --wait
echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${DEPLOYMENT_NAME}
  namespace: ${NAMESPACE}
  labels:
    app: spring-boot-api-${ENVIRONMENT}
spec:
  replicas: ${REPLICAS}
  selector:
    matchLabels:
      app: spring-boot-api-${ENVIRONMENT}
  template:
    metadata:
      labels:
        app: spring-boot-api-${ENVIRONMENT}
    spec:
      containers:
      - name: spring-boot-api-${ENVIRONMENT}
        image: ${ACR}.azurecr.io/spring-demo-api:${IMAGE_VERSION}
        imagePullPolicy: Always
        resources:
          requests:
            memory: '1024Mi'
            cpu: '1'
          limits:
            memory: '2048Mi'
            cpu: '2'
        ports:
          - containerPort: ${HTTPS_CONTAINER_PORT}
            name: https
        ports:
          - name: liveness-port
            containerPort: 8443
        livenessProbe:
          httpGet:
            scheme: HTTPS
            path: /
            port: ${HTTP_CONTAINER_PORT}
          initialDelaySeconds: 3
          periodSeconds: 10
          timeoutSeconds: 30
          successThreshold: 1
          failureThreshold: 5
      imagePullSecrets:
        - name: ${PULL_SECRET}
" > deployment.yaml

# Deploy the application containers to the cluster with kubernetes
kubectl apply -f deployment.yaml -o json --wait --timeout 90s
