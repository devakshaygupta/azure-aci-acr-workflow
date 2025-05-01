#!/bin/bash

# This script updates the <p> tag in index.html with the latest word count.

# Define the input file path
APP_FILE="/app/app.py"
HTML_FILE="/app/index.html"

# Check if the input file exists
if [ ! -f "$APP_FILE" ]; then
    echo "❌ Input file $APP_FILE not found. Please check the file path."
    exit 1
fi

# Calculate the word count
WORD_COUNT=$(python3 -c "import sys; print(len(open('$APP_FILE').read().split()))")

# Update the HTML file with the word count
sed -i "s|<p>Word Count: .*<\/p>|<p>Word Count: $WORD_COUNT</p>|" "$HTML_FILE"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
    echo "❌ Failed to update $HTML_FILE. Please check the file."
    exit 1
fi

echo "✔️ $HTML_FILE updated successfully with word count: $WORD_COUNT"