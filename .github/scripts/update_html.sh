#!/bin/bash

# File paths
DATA_FILE="/app/data.txt"
HTML_FILE="/app/index.html"

# Check if the data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Data file $DATA_FILE not found."
    exit 1
fi

# Check if the HTML file exists
if [ ! -f "$HTML_FILE" ]; then
    echo "❌ HTML file $HTML_FILE not found."
    exit 1
fi

# Calculate the word count from data.txt
WORD_COUNT=$(python3 -c "print(len(open('$DATA_FILE').read().split()))")

# Debugging: Print the calculated word count
echo "🔍 Calculated Word Count: $WORD_COUNT"

# Debugging: Print the current content of the HTML file
echo "🔍 Current HTML content:"
cat "$HTML_FILE"

# Update the specific <p id="wordcount"> tag
sed -i "s|<p id=\"wordcount\">.*</p>|<p id=\"wordcount\">Word Count = $WORD_COUNT</p>|" "$HTML_FILE"

# Verify if the sed command succeeded
if [ $? -ne 0 ]; then
    echo "❌ Failed to update $HTML_FILE. Please check the file."
    exit 1
fi

# Debugging: Print the updated content of the HTML file
echo "🔍 Updated HTML content:"
cat "$HTML_FILE"

echo "✔️ $HTML_FILE updated successfully with word count: $WORD_COUNT"
