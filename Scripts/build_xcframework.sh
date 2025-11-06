#!/bin/bash

# OptSVGAPlayer XCFramework Build Script
# This script builds OptSVGAPlayer.xcframework containing SVGAPlayer + SVGARePlayer + SVGAExPlayer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Building OptSVGAPlayer.xcframework${NC}"
echo -e "${GREEN}========================================${NC}"

# Configuration
WORKSPACE="Demo/Demo.xcworkspace"
SCHEME="OptSVGAPlayer"
BUILD_DIR="Demo/build"
XCFRAMEWORK_NAME="OptSVGAPlayer.xcframework"

# Clean previous build
echo -e "\n${YELLOW}Cleaning previous build...${NC}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# Archive for iOS Device
echo -e "\n${YELLOW}Archiving for iOS Device (arm64)...${NC}"
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -destination "generic/platform=iOS" \
  -archivePath "${BUILD_DIR}/${SCHEME}-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  ONLY_ACTIVE_ARCH=NO \
  -skipMacroValidation \
  EXCLUDED_SOURCE_FILE_NAMES="*-dynamic*" \
  2>&1 | grep -E "error:|warning:|Compiling|Linking|Building|Creating|note:|▸" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo -e "${RED}❌ iOS Device archive failed!${NC}"
  exit 1
fi

# Archive for iOS Simulator (arm64 only)
echo -e "\n${YELLOW}Archiving for iOS Simulator (arm64 only)...${NC}"
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${BUILD_DIR}/${SCHEME}-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  ONLY_ACTIVE_ARCH=NO \
  ARCHS="arm64" \
  VALID_ARCHS="arm64" \
  -skipMacroValidation \
  EXCLUDED_SOURCE_FILE_NAMES="*-dynamic*" \
  2>&1 | grep -E "error:|warning:|Compiling|Linking|Building|Creating|note:|▸" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
  echo -e "${RED}❌ iOS Simulator archive failed!${NC}"
  exit 1
fi

# Create XCFramework
echo -e "\n${YELLOW}Creating XCFramework...${NC}"
xcodebuild -create-xcframework \
  -framework "${BUILD_DIR}/${SCHEME}-iOS.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -framework "${BUILD_DIR}/${SCHEME}-Simulator.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -output "${BUILD_DIR}/${XCFRAMEWORK_NAME}"

# Success
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ XCFramework created successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Location: ${BUILD_DIR}/${XCFRAMEWORK_NAME}"
echo -e "\nFramework size:"
du -sh "${BUILD_DIR}/${XCFRAMEWORK_NAME}"

# Display framework contents
echo -e "\n${YELLOW}Framework contents:${NC}"
ls -lh "${BUILD_DIR}/${XCFRAMEWORK_NAME}"

echo -e "\n${GREEN}Done!${NC}"
