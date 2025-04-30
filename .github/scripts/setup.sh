#!/bin/bash

# One-time Azure login + ACR + resource group + service principal + GitHub Secrets

# Variables
RESOURCE_GROUP="wordcount-rg"
ACR_NAME="wordcountacr$(date +%s)"  # Unique ACR name
LOCATION="australiaeast"
SP_NAME="github-actions-sp"

# Check for Azure CLI
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it and try again."
    exit 1
fi

# Azure Login
echo "🔐 Logging into Azure..."
az login --use-device-code
if [ $? -ne 0 ]; then
    echo "❌ Azure login failed. Please check your credentials."
    exit 1
fi
echo "✅ Azure login successful."

# Subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo "📘 Subscription ID: $SUBSCRIPTION_ID"

# Check or Create Resource Group
echo "📁 Checking if resource group '$RESOURCE_GROUP' exists..."
if az group exists --name "$RESOURCE_GROUP"; then
    echo "✅ Resource group '$RESOURCE_GROUP' already exists."
else
    echo "📁 Creating resource group..."
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create resource group."
        exit 1
    fi
    echo "✅ Resource group '$RESOURCE_GROUP' created."
fi

# Create ACR
echo "📦 Creating Azure Container Registry..."
az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$ACR_NAME" \
  --sku Basic \
  --location "$LOCATION" \
  --admin-enabled true
if [ $? -ne 0 ]; then
    echo "❌ Failed to create Azure Container Registry."
    exit 1
fi
echo "✅ ACR '$ACR_NAME' created."

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
echo "✅ 'AcrPush' role assigned to the service principal for ACR."

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query "passwords[0].value" -o tsv)

# Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "⚠️ GitHub CLI is not installed. You will need to manually set the secrets."
fi

# Upload secrets using GitHub CLI if available
if command -v gh &> /dev/null; then
  echo "🔗 Setting GitHub Actions secrets..."
  gh secret set AZURE_CREDENTIALS --body "$AZURE_CREDENTIALS"
  gh secret set ACR_USERNAME --body "$ACR_USERNAME"
  gh secret set ACR_PASSWORD --body "$ACR_PASSWORD"
  if [ $? -eq 0 ]; then
    echo "✅ GitHub secrets 'AZURE_CREDENTIALS', 'ACR_USERNAME', and 'ACR_PASSWORD' set successfully."
  else
    echo "⚠️ Failed to set GitHub secrets. Please run 'gh auth login' and try again."
  fi
fi

echo "🎉 Setup complete."
