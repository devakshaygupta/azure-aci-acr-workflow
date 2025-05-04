#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input variables
RESOURCE_GROUP="wordcount-rg" # Resource group name
ACI_NAME=""                   # Will be dynamically fetched
ACR_NAME=""                   # Will be dynamically fetched

# Step 1: List the Azure Container Registry (ACR) in the Resource Group
echo "📋 Listing Azure Container Registry in Resource Group: $RESOURCE_GROUP..."
ACR_NAME=$(az acr list --resource-group "$RESOURCE_GROUP" --query "[0].name" -o tsv)

if [ -z "$ACR_NAME" ]; then
  echo "❌ No Azure Container Registry found in Resource Group: $RESOURCE_GROUP."
else
  echo "✔️ Found Azure Container Registry: $ACR_NAME"
fi

# Step 2: List the Azure Container Instances (ACI) in the Resource Group
echo "📋 Listing Azure Container Instances in Resource Group: $RESOURCE_GROUP..."
ACI_NAME=$(az container list --resource-group "$RESOURCE_GROUP" --query "[0].name" -o tsv)

if [ -z "$ACI_NAME" ]; then
  echo "❌ No Azure Container Instance found in Resource Group: $RESOURCE_GROUP."
else
  echo "✔️ Found Azure Container Instance: $ACI_NAME"
fi

# Step 3: Delete the Azure Container Instance (ACI)
if [ -n "$ACI_NAME" ]; then
  echo "🗑️ Deleting Azure Container Instance: $ACI_NAME..."
  az container delete \
    --name "$ACI_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --yes
  echo "✔️ Azure Container Instance deleted."
else
  echo "⚠️ Skipping ACI deletion as no instance was found."
fi

# Step 4: Delete the Azure Container Registry (ACR)
if [ -n "$ACR_NAME" ]; then
  echo "🗑️ Deleting Azure Container Registry: $ACR_NAME..."
  az acr delete \
    --name "$ACR_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --yes
  echo "✔️ Azure Container Registry deleted."
else
  echo "⚠️ Skipping ACR deletion as no registry was found."
fi

# Step 5: Delete the Resource Group
echo "🗑️ Deleting Resource Group: $RESOURCE_GROUP..."
az group delete \
  --name "$RESOURCE_GROUP" \
  --yes --no-wait
echo "✔️ Resource Group deletion initiated."

echo "🎉 Cleanup completed successfully!"