#!/usr/bin/env sh

# Set the parent directory
PARENT_DIR="$PWD/.."

# Define the paths for the input .7z file and the output .zip file
INPUT_7Z_FILE="$PARENT_DIR/AuroraEditorSupportedLanguages.xcframework.7z"
OUTPUT_ZIP_FILE="$PARENT_DIR/AuroraEditorSupportedLanguages.xcframework.zip"
TEMP_DIR="$PARENT_DIR/Tools/temp"

# Remove any existing .zip file
if [ -f "$OUTPUT_ZIP_FILE" ]; then
    echo "Removing existing .zip file..."
    rm "$OUTPUT_ZIP_FILE"
fi

# Check if the .7z file exists
if [ ! -f "$INPUT_7Z_FILE" ]; then
    echo "Error: .7z file not found at $INPUT_7Z_FILE"
    exit 1
fi

# Ensure the temporary directory exists
mkdir -p "$TEMP_DIR"

# Extract the .7z file
7z x "$INPUT_7Z_FILE" -o"$TEMP_DIR"

# Check if the extraction was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract .7z file"
    exit 1
fi

# Change to the temporary directory
cd "$TEMP_DIR"

# Compress the extracted files into a .zip file
zip -r -9 "$OUTPUT_ZIP_FILE" .

# Check if the compression was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to create .zip file"
    exit 1
fi

# Remove the .7z file after successful conversion
if [ -f "$INPUT_7Z_FILE" ]; then
    echo "Removing the .7z file..."
    rm "$INPUT_7Z_FILE"
fi

# Optional: Remove the temporary directory after compression
cd ..
rm -rf "$TEMP_DIR"

echo "Conversion from .7z to .zip completed"
