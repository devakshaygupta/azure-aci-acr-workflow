#!/bin/bash

# File paths
DATA_FILE="/app/data.txt"
HTML_FILE="/app/index.html"


# Calculate the word count from data.txt
WORD_COUNT=$(python3 -c "print(len(open('$DATA_FILE').read().split()))")

# Debugging: Print the calculated word count
echo "🔍 Calculated Word Count: $WORD_COUNT"

# Update the specific <p id="wordcount"> tag
echo "⏳ Calculated Word Count $WORD_COUNT to $HTML_FILE"
sed -i "s|<p id=\"wordcount\">.*</p>|<p id=\"wordcount\">Word Count = $WORD_COUNT</p>|" "$HTML_FILE"

echo "✔️ $HTML_FILE updated successfully with word count: $WORD_COUNT"
