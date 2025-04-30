#!/bin/bash

set -e

# Commit changes to index.html and push to the remote repository
git config --global user.name "github-actions"
git config --global user.email "actions@github.com"
git add index.html
git commit -m "Update word count"
git push origin main

# Check if the git push was successful
if [ $? -ne 0 ]; then
    echo "Failed to push changes to the remote repository. Please check your git settings."
    exit 1
fi
echo "✔️ Changes pushed to the remote repository successfully."