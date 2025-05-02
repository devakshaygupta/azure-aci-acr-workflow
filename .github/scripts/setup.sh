#!/bin/bash

# One-time Azure login + ACR + resource group + service principal + GitHub Secrets

# Variables
RESOURCE_GROUP="wordcount-rg"
ACR_NAME="wordcountacr$(date +%s)"  # Unique ACR name
LOCATION="australiaeast"
SP_NAME="github-actions-sp"
OWNER="Georges034302"
REPO="azure-aci-acr-workflow"


# Azure Login
echo "🔐 Logging into Azure..."
az login --use-device-code

echo "✅ Azure login successful."

# Subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "📘 Subscription ID: $SUBSCRIPTION_ID"

# Create or Confirm Resource Group
echo "📁 Creating or confirming resource group '$RESOURCE_GROUP'..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none
if [ $? -ne 0 ]; then
    echo "❌ Failed to create or verify resource group."
    exit 1
fi
echo "✅ Resource group '$RESOURCE_GROUP' is ready."

# Propagation wait for ACR availability
echo "⏳ Waiting for resource group to propagate..."
sleep 10

# Create ACR with retry
echo "📦 Creating Azure Container Registry with retry logic..."
ACR_CREATED=0
for attempt in {1..5}; do
  az acr create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$ACR_NAME" \
    --sku Basic \
    --location "$LOCATION" \
    --admin-enabled true \
    --only-show-errors \
    --output none && {
      ACR_CREATED=1
      echo "✅ ACR '$ACR_NAME' created."
      break
  }

  echo "⚠️ Attempt $attempt failed. Retrying in 10 seconds..."
  sleep 10

done

# Create Service Principal
echo "🔐 Creating GitHub Actions service principal..."
AZURE_CREDENTIALS=$(az ad sp create-for-rbac \
  --name "$SP_NAME" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP \
  --sdk-auth)

if [ $? -ne 0 ]; then
    echo "❌ Failed to create service principal."
    exit 1
fi
echo "✅ Service principal '$SP_NAME' created."

# Debugging AZURE_CREDENTIALS
echo "🔍 Debugging AZURE_CREDENTIALS:"
echo "$AZURE_CREDENTIALS" | jq

# Validate AZURE_CREDENTIALS JSON
if ! echo "$AZURE_CREDENTIALS" | jq empty; then
    echo "❌ Invalid AZURE_CREDENTIALS JSON. Please check the Service Principal creation step."
    exit 1
fi

# Assign RBAC Role for ACR
echo "🔑 Assigning 'AcrPush' role to the service principal for ACR..."
SP_APP_ID=$(echo "$AZURE_CREDENTIALS" | jq -r '.clientId')
ACR_ID=$(az acr show --name "$ACR_NAME" --query id -o tsv)

az role assignment create \
  --assignee "$SP_APP_ID" \
  --role "AcrPush" \
  --scope "$ACR_ID"

if [ $? -ne 0 ]; then
    echo "❌ Failed to assign 'AcrPush' role to the service principal."
    exit 1
fi
echo "✅ 'AcrPush' role assigned."

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query "passwords[0].value" -o tsv)

# Debugging ACR Credentials
echo "🔍 Debugging ACR Credentials:"
echo "ACR_USERNAME: $ACR_USERNAME"
echo "ACR_PASSWORD: $ACR_PASSWORD"

# Set GitHub Secrets if authenticated
if ! command -v gh &> /dev/null; then
    echo "⚠️ GitHub CLI not installed. Please set secrets manually."
elif gh auth status &> /dev/null; then
    echo "🔗 Setting GitHub Actions secrets..."
    echo "$AZURE_CREDENTIALS" | gh secret set AZURE_CREDENTIALS --repo "$OWNER/$REPO"
    gh secret set ACR_USERNAME --body "$ACR_USERNAME" --repo "$OWNER/$REPO"
    gh secret set ACR_PASSWORD --body "$ACR_PASSWORD" --repo "$OWNER/$REPO"
    gh secret set ACR_NAME --body "$ACR_NAME" --repo "$OWNER/$REPO"  # Add ACR_NAME secret
    gh secret set RESOURCE_GROUP --body "$RESOURCE_GROUP" --repo "$OWNER/$REPO"  # Add RESOURCE_GROUP secret
    gh secret set SP_APP_ID --body "$SP_APP_ID" --repo "$OWNER/$REPO"  # Add SP_APP_ID secret
    gh secret set SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID" --repo "$OWNER/$REPO"  # Add SUBSCRIPTION_ID secret
    gh secret set LOCATION --body "$LOCATION" --repo "$OWNER/$REPO"  # Add LOCATION secret
    gh secret set SP_NAME --body "$SP_NAME" --repo "$OWNER/$REPO"  # Add SP_NAME secret
    echo "✅ GitHub secrets set."
else
    echo "⚠️ GitHub CLI not authenticated. Run 'gh auth login'."
fi

echo "🎉 Setup complete."
