#!/bin/bash
set -e

PORT=${PORT:-80} # Default to port 80 if not set

# Login to ACR
echo "🔐 Logging into ACR..."
az acr login --name "$ACR_NAME"

# Deploy to Azure Container Instances
echo "📦 Deploy Docker app to ACI..."
az container create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$ACI_NAME" \
  --image "$ACR_NAME.azurecr.io/wordcount:latest" \
  --dns-name-label "$DNS_LABEL" \
  --ports "$PORT" \
  --location "$LOCATION" \
  --os-type Linux \
  --cpu 2 \
  --memory 2 \
  --registry-login-server "$ACR_NAME.azurecr.io" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD"

# Retrieve FQDN
echo "⏳ Fetching FQDN..."
FQDN=$(az container show \
  --name "$ACI_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query ipAddress.fqdn -o tsv)

echo "✔️ App deployed successfully."
echo "🌐 App deployed at: http://$FQDN"
