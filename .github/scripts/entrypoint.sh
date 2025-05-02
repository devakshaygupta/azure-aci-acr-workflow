#!/bin/bash

# Entry point script to orchestrate the execution of all other scripts in order

# Step 1: Update the HTML file with the new word count
bash /app/scripts/update_html.sh

# Step 2: Start Apache2 to serve the updated HTML file
echo "Starting Apache2 to serve index.html..."
apachectl -D FOREGROUND