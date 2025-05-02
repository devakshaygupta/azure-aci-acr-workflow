#!/bin/bash

# Entry point script to orchestrate the execution of all other scripts in order

# Step 1: Update the HTML file with the new word count
bash /app/scripts/update_html.sh

# Step 2: Update the README file with the new FQDN
bash /app/scripts/update_readme.sh "$DNS_LABEL" "$LOCATION"

# Step 3: Commit and push the changes to the repository
bash /app/scripts/git_push.sh

# Step 4: Start the Python HTTP server to serve the index.html file
echo "Starting Python HTTP server to serve index.html..."
cd /app
python3 -m http.server 80