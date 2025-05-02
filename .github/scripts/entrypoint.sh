#!/bin/bash

# Entry point script to orchestrate the execution of all other scripts in order

# Step 1: Update the HTML file with the new word count
bash /app/scripts/update_html.sh

# Step 2: Commit and push the changes to the repository
# bash /app/scripts/git_push.sh