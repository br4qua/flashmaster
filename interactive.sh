#!/bin/bash

# Interactive CSV entry script
# Reads headers from template.csv and prompts user for each field
# Appends the result to test.csv

TEMPLATE_FILE="template.csv"
OUTPUT_FILE="test.csv"

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: $TEMPLATE_FILE not found!"
    echo "Create a template.csv file with column headers."
    exit 1
fi

# Read the first line (headers) from template.csv
HEADERS=$(head -n 1 "$TEMPLATE_FILE")

# Convert headers to array, splitting on commas
IFS=',' read -ra HEADER_ARRAY <<< "$HEADERS"

echo "=== Interactive CSV Entry ==="
echo "Enter data for each field:"
echo ""

# Array to store user inputs
declare -a VALUES

# Prompt for each field
for i in "${!HEADER_ARRAY[@]}"; do
    FIELD="${HEADER_ARRAY[$i]}"
    # Remove any quotes or whitespace from field name    
    echo -n "$FIELD: "
    read -r VALUE
    
    # Escape any quotes in the value and wrap in quotes if it contains commas
    if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *"\""* ]]; then
        VALUE=$(echo "$VALUE")
        VALUE="\"$VALUE\""
    fi
    
    VALUES[$i]="$VALUE"
done

# Build the CSV row
CSV_ROW=""
for i in "${!VALUES[@]}"; do
    if [ $i -eq 0 ]; then
        CSV_ROW="${VALUES[$i]}"
    else
        CSV_ROW="$CSV_ROW,${VALUES[$i]}"
    fi
done

echo ""
echo "Generated row: $CSV_ROW"
echo ""

# Confirm before adding
echo -n "Add this row to $OUTPUT_FILE? (y/N): "
read -r CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    # Create output file with headers if it doesn't exist
    if [ ! -f "$OUTPUT_FILE" ]; then
        echo "Creating $OUTPUT_FILE with headers..."
        echo "$HEADERS" > "$OUTPUT_FILE"
    fi
    
    # Append the new row
    echo "$CSV_ROW" >> "$OUTPUT_FILE"
    echo "✓ Row added to $OUTPUT_FILE"
else
    echo "Cancelled."
fi
