#!/usr/bin/env sh

# Convenience function to print a status message in green
status() {
    local GREEN='\033[0;32m'
    local NO_COLOR='\033[0m'
    echo "${GREEN}◆ $1${NO_COLOR}"
}

# Set flags based on the presence of the --debug argument
if [ "$1" = "--debug" ]; then
    BUILD_FLAG=""
    BUILD_OUTPUT_DESTINATION=/dev/stdout
else
    BUILD_FLAG="-quiet"
    BUILD_OUTPUT_DESTINATION=/dev/null
fi

# Check if the script is running in a GitHub Actions environment
if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
    GITHUB_MODE=true
else
    GITHUB_MODE=false
fi

# Ensures the script exits if a command fails, an undefined variable is used, or a command in a pipeline fails
set -euo pipefail

# Define key path variables based on the environment
if [ "$GITHUB_MODE" = true ]; then
    GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-$PWD}"
    PARENT_DIR="$GITHUB_WORKSPACE"
else
    PARENT_DIR="$PWD/.."
fi

PRODUCTS_PATH="$PARENT_DIR/DerivedData/Build/Products/Release"
FRAMEWORK_PATH="$PRODUCTS_PATH/AuroraEditorSupportedLanguages.framework"
OUTPUT_PATH="$PARENT_DIR/AuroraEditorSupportedLanguages.xcframework"
CHECKOUTS_PATH="$PARENT_DIR/DerivedData/SourcePackages/checkouts"
RESOURCES_PATH="$PARENT_DIR/Sources/AuroraEditorLanguage/Resources"

# Remove previously generated files, if they exist
[ -e "$OUTPUT_PATH" ] && rm -rf "$OUTPUT_PATH"
[ -e "$OUTPUT_PATH.zip" ] && rm -f "$OUTPUT_PATH.zip"
status "Removed previous generated files!"

# Begin building the framework project
status "Clean Building AuroraEditorSupportedLanguages.xcodeproj..."
xcodebuild -project $PARENT_DIR/AuroraEditorSupportedLanguages/AuroraEditorSupportedLanguages.xcodeproj \
    -scheme AuroraEditorSupportedLanguages \
    -destination "platform=macOS" \
    -derivedDataPath "$PARENT_DIR/DerivedData" \
    -configuration Release \
    $BUILD_FLAG clean build > "$BUILD_OUTPUT_DESTINATION"
status "Build complete!"

# Create the binary xcframework from the built framework
status "Creating AuroraEditorSupportedLanguages.xcframework..."
xcodebuild -create-xcframework \
    -framework "$FRAMEWORK_PATH" \
    -output "$OUTPUT_PATH" > "$BUILD_OUTPUT_DESTINATION"  # Package framework into xcframework

# Use zip for compression of the xcframework
status "Compressing AuroraEditorSupportedLanguages.xcframework with zip..."
zip -y -r -9 "$OUTPUT_PATH.zip" "$OUTPUT_PATH" > "$BUILD_OUTPUT_DESTINATION"

# Remove the uncompressed xcframework after zipping
rm -rf "$OUTPUT_PATH"
status "AuroraEditorSupportedLanguages.xcframework.zip created!"

# Copy language query files to the package resources
status "Copying language queries to package resources..."
[ -e "$RESOURCES_PATH" ] && rm -rf "$RESOURCES_PATH"  # Remove existing resources before copying

# Find and process language queries
LIST=$( echo $CHECKOUTS_PATH/tree-* )

OLD_PWD="$PWD"  # Store the current directory for later use

# Loop through each language directory in the list
for lang in $LIST ; do
    cd $lang  # Change to the language-specific directory

    # Extract package information and target paths using Swift Package Manager and jq
    manifest=$(swift package dump-package)  # Dump package info into a variable
    targets=$(echo $manifest | jq -r '.targets[] | select(.type != "test") | .path')  # Parse target paths
    count=$(echo $manifest | jq '[.targets[] | select(.type != "test")] | length')  # Count the number of targets

    # Check if all target paths are identical (all '.')
    same=1
    for target in $targets; do
        if [[ $target != "." ]]; then
            same=0
            break
        fi
    done

    # Process each target
    for target in $targets; do
        name=${lang##*/}  # Extract the name of the language package
        
        # Create directories for resources based on target count and structure
        if [[ $count -eq 1 || ($count -ne 1 && $same -eq 1) ]]; then
            mkdir -p $RESOURCES_PATH/$name
        else
            mkdir -p $RESOURCES_PATH/$target
        fi
            
        # Find and copy highlight files to the appropriate resource directory
        highlights=$( find $lang/$target -type f -name "*.scm" )
        for highlight in $highlights ; do
            highlight_name=${highlight##*/}
            if [[ $count -eq 1 || ($count -ne 1 && $same -eq 1) ]]; then
                cp $highlight $RESOURCES_PATH/$name/$highlight_name
            else
                cp $highlight $RESOURCES_PATH/$target/$highlight_name
            fi
        done
        
        # If all target paths are '.', no need to process further
        if [[ $same -eq 1 || ($count -ne 1 && $same -eq 1) ]]; then
            break
        fi
    done
done
status "Language queries copied to package resources!"

# Return to the original directory and perform cleanup
cd $OLD_PWD
if [ -d "$PARENT_DIR/DerivedData" ]; then
    status "Cleaning up DerivedData..."
    rm -rf "$PARENT_DIR/DerivedData"  # Remove DerivedData directory to clean up
fi

status "Done!"  # Indicate the end of the script
