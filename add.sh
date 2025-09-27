#!/bin/bash

# Script to add a data row to a CSV file
# Usage: ./add_row_to_csv.sh [-o output_file] [csv_file] "csv_row"

OUTPUT_FILE=""
CSV_FILE="data.csv"
NEW_ROW=""

# Parse -o flag
if [ "$1" = "-o" ]; then
    OUTPUT_FILE="$2"
    shift 2
fi

# Parse remaining arguments
if [ $# -eq 1 ]; then
    NEW_ROW="$1"
elif [ $# -eq 2 ]; then
    CSV_FILE="$1"
    NEW_ROW="$2"
else
    echo "Usage: $0 [-o output_file] [csv_file] \"csv_row\""
    exit 1
fi

# Set target file
if [ -z "$OUTPUT_FILE" ]; then
    TARGET_FILE="$CSV_FILE"
else
    TARGET_FILE="$OUTPUT_FILE"
    # Copy original to output if it doesn't exist
    if [ ! -f "$TARGET_FILE" ]; then
        cp "$CSV_FILE" "$TARGET_FILE"
    fi
fi

# Just append the line
echo "$NEW_ROW" >> "$TARGET_FILE"

echo "✓ Added: $NEW_ROW"
echo "✓ File: $TARGET_FILE"
