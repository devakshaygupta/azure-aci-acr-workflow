#!/bin/bash
set -e

# Parameters
ACR_NAME=${ACR_NAME:-"myacrdemo"}
RESOURCE_GROUP=${RESOURCE_GROUP:-"myResourceGroup"}
ACI_NAME=${ACI_NAME:-"wordcount-app"}
DNS_LABEL=${DNS_LABEL:-"wordcountdemo"}
LOCATION=${LOCATION:-"australiaeast"}
PORT=${PORT:-80}

# Check for required environment variables
if [ -z "$ACR_USERNAME" ] || [ -z "$ACR_PASSWORD" ]; then
    echo "❌ ACR_USERNAME or ACR_PASSWORD is not set. Please set these environment variables and try again."
    exit 1
fi

# Check if ACR exists
if ! az acr show --name "$ACR_NAME" &> /dev/null; then
    echo "❌ ACR '$ACR_NAME' does not exist. Please create it before running this script."
    exit 1
fi

# Check if Resource Group exists
if ! az group exists --name "$RESOURCE_GROUP"; then
    echo "❌ Resource group '$RESOURCE_GROUP' does not exist. Please create it before running this script."
    exit 1
fi

# Login to ACR
az acr login --name "$ACR_NAME"

# Deploy to Azure Container Instances
az container create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$ACI_NAME" \
  --image "$ACR_NAME.azurecr.io/wordcount:latest" \
  --dns-name-label "$DNS_LABEL" \
  --ports "$PORT" \
  --location "$LOCATION" \
  --registry-login-server "$ACR_NAME.azurecr.io" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD"

# Retrieve FQDN
FQDN=$(az container show \
  --name "$ACI_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query ipAddress.fqdn -o tsv)

if [ -z "$FQDN" ]; then
    echo "❌ Failed to retrieve the FQDN. Please check the deployment."
    exit 1
fi

echo "✔️ App deployed successfully."
echo "🌐 App deployed at: http://$FQDN"
