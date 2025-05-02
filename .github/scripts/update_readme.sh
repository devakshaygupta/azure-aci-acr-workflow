#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input variables
README_FILE="README.md"
DNS_LABEL=$1
LOCATION=$2

# Validate inputs
if [ -z "$DNS_LABEL" ] || [ -z "$LOCATION" ]; then
  echo "❌ Error: DNS_LABEL and LOCATION are required."
  echo "Usage: bash update_readme.sh <DNS_LABEL> <LOCATION>"
  exit 1
fi

# Construct the new FQDN
NEW_FQDN="http://${DNS_LABEL}.${LOCATION}.azurecontainer.io"

# Debugging: Print the new FQDN
echo "🔍 New FQDN: $NEW_FQDN"

# Check if README.md exists
if [ ! -f "$README_FILE" ]; then
  echo "❌ Error: $README_FILE not found."
  exit 1
fi

# Debugging: Print the current contents of README.md
echo "🔍 Current README.md contents:"
cat "$README_FILE"

# Update the FQDN in the README.md file
if grep -q "http://.*.azurecontainer.io" "$README_FILE"; then
  sed -i "s|http://.*.azurecontainer.io|$NEW_FQDN|g" "$README_FILE"
  echo "✔️ README.md updated successfully with FQDN: $NEW_FQDN"
else
  echo "❌ Error: No matching FQDN pattern found in $README_FILE. No changes made."
  exit 1
fi

# Debugging: Print the updated contents of README.md
echo "🔍 Updated README.md contents:"
cat "$README_FILE"