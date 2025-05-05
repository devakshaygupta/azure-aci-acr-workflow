#!/bin/bash

set -e

# Configure Git
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

# Commit changes to index.html and README.md and push to the remote repository
git add index.html README.md
git commit -m "Update word count and README"
git push

echo "✔️ Changes to index.html and README.md pushed to the remote repository successfully."