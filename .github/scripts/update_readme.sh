#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input variables
README_FILE="README.md"
DNS_LABEL=$1
LOCATION=$2

# Construct the new FQDN
NEW_FQDN="http://${DNS_LABEL}.${LOCATION}.azurecontainer.io"

# Debugging: Print the new FQDN
echo "🔍 New FQDN: $NEW_FQDN"

# Update the FQDN in the README.md file
sed -i "s|http://.*.azurecontainer.io|$NEW_FQDN|g" "$README_FILE"

# Confirm the update
echo "✔️ README.md updated successfully with FQDN: $NEW_FQDN"