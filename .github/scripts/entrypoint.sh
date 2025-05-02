#!/bin/bash

# Entry point script to orchestrate the execution of all other scripts in order

# Step 1: Update the HTML file with the new word count
bash /app/scripts/update_html.sh

# Step 2: Start a simple HTTP server to serve the updated HTML file
echo "Starting HTTP server to serve index.html..."
python3 -m http.server --directory /app 80