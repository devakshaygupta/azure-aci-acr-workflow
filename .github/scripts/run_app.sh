#!/bin/bash

# Run the Python application and capture the word count output
word_count=$(python3 ../apps/app.py) 
# Check if the Python script executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to run the Python application. Please check the script."
    exit 1
fi
# Check if the output is a valid number
if ! [[ "$word_count" =~ ^[0-9]+$ ]]; then
    echo "The output is not a valid number. Please check the Python script."
    exit 1
fi
# Print the word count
echo "Word Count: $word_count"