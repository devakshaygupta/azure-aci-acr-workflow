#!/bin/bash

# Define the Python application path
APP_FILE="/app/app.py"

# Check if the Python application file exists
if [ ! -f "$APP_FILE" ]; then
    echo "❌ Python application file $APP_FILE not found. Please check the file path."
    exit 1
fi

# Run the Python application and capture the word count output
word_count=$(python3 "$APP_FILE")

# Check if the Python script executed successfully
if [ $? -ne 0 ]; then
    echo "❌ Failed to run the Python application. Please check the script."
    exit 1
fi

# Check if the output is a valid number
if ! [[ "$word_count" =~ ^[0-9]+$ ]]; then
    echo "❌ The output is not a valid number. Please check the Python script."
    exit 1
fi

# Print the word count
echo "✔️ Word Count: $word_count"