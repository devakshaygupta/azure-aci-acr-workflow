#!/bin/bash

# Entry point script to orchestrate the execution of all other scripts in order

# Step 1: Setup Azure and resources
bash /app/scripts/setup.sh

# Step 2: Run the Python application to get the word count
bash /app/scripts/run_app.sh

# Step 3: Update the HTML file with the new word count
bash /app/scripts/update_html.sh

# Step 4: Commit and push the changes to the repository
bash /app/scripts/git_push.sh

# Step 5: Deploy the application to Azure Container Instances
bash /app/scripts/deploy.sh