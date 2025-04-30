#!/bin/bash

# This script updates the <p> tag in index.html with the latest word count.
WORD_COUNT=$(cat ../apps/app.py | python3 -c "import sys; print(len(sys.stdin.read().split()))")

sed -i "s|<p>Word Count: .*<\/p>|<p>Word Count: $WORD_COUNT</p>|" ../index.html
# Check if the sed command was successful
if [ $? -ne 0 ]; then
    echo "Failed to update index.html. Please check the file."
    exit 1
fi
echo "✔️ index.html updated successfully with word count: $WORD_COUNT"