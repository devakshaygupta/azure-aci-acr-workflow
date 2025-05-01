#!/bin/bash

set -e

# Configure Git
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

# Commit changes to index.html and push to the remote repository
git add index.html
git commit -m "Update word count"
git push

echo "✔️ Changes pushed to the remote repository successfully."