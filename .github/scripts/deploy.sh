#!/bin/bash
set -e

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
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
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
