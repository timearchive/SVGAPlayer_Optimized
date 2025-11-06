#!/bin/bash

# Complete Setup Script for OptSVGAPlayer XCFramework
# This script guides you through the entire setup process

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================"
echo -e "OptSVGAPlayer XCFramework Setup"
echo -e "========================================${NC}\n"

# Step 1: Check dependencies
echo -e "${YELLOW}Step 1: Checking dependencies...${NC}"

if ! command -v pod &> /dev/null; then
    echo -e "${RED}❌ CocoaPods not found!${NC}"
    echo -e "Please install: sudo gem install cocoapods"
    exit 1
fi
echo -e "${GREEN}✅ CocoaPods found${NC}"

if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Xcode command line tools not found!${NC}"
    echo -e "Please install Xcode and command line tools"
    exit 1
fi
echo -e "${GREEN}✅ Xcode found${NC}"

# Check for xcodeproj gem
if command -v xcodeproj &> /dev/null; then
    echo -e "${GREEN}✅ xcodeproj gem found${NC}"
    HAS_XCODEPROJ=true
else
    echo -e "${YELLOW}⚠️  xcodeproj gem not found${NC}"
    echo -e "Optional: Install with 'gem install xcodeproj' for automation"
    HAS_XCODEPROJ=false
fi

# Step 2: Run pod install
echo -e "\n${YELLOW}Step 2: Installing CocoaPods dependencies...${NC}"
cd Demo
pod install
cd ..
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Step 3: Attempt to use Ruby script if available
if [ "$HAS_XCODEPROJ" = true ]; then
    echo -e "\n${YELLOW}Step 3: Running automated Xcode configuration...${NC}"
    if ./Scripts/setup_xcode_target.rb; then
        echo -e "${GREEN}✅ Xcode target configured automatically${NC}"
        AUTO_SETUP=true
    else
        echo -e "${RED}❌ Automated setup failed${NC}"
        AUTO_SETUP=false
    fi
else
    AUTO_SETUP=false
fi

# Step 4: Manual instructions
if [ "$AUTO_SETUP" = false ]; then
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}Manual Configuration Required${NC}"
    echo -e "${BLUE}========================================${NC}\n"

    echo -e "Please complete the following steps in Xcode:\n"

    echo -e "${YELLOW}1. Create Framework Target:${NC}"
    echo -e "   - Open Demo/Demo.xcodeproj in Xcode"
    echo -e "   - File → New → Target → Framework"
    echo -e "   - Name: OptSVGAPlayer"
    echo -e "   - Language: Objective-C"
    echo -e "   - iOS Deployment Target: 12.0\n"

    echo -e "${YELLOW}2. Add Source Files:${NC}"
    echo -e "   Add these files to OptSVGAPlayer target:"
    echo -e "   - ../SVGAPlayer_Optimized/SVGARePlayer.{h,m}"
    echo -e "   - ../SVGAPlayer_Optimized/SVGAExPlayer.swift"
    echo -e "   - ../SVGAPlayer_Optimized/SVGAVideoEntity+Extension.{h,m}"
    echo -e "   - Demo/OptSVGAPlayer/OptSVGAPlayer.h"
    echo -e "   - Demo/OptSVGAPlayer/Info.plist\n"

    echo -e "${YELLOW}3. Configure Headers:${NC}"
    echo -e "   Build Phases → Headers → Set as Public:"
    echo -e "   - OptSVGAPlayer.h"
    echo -e "   - SVGARePlayer.h"
    echo -e "   - SVGAVideoEntity+Extension.h\n"

    echo -e "${YELLOW}4. Link Frameworks:${NC}"
    echo -e "   Open Demo/Demo.xcworkspace (NOT xcodeproj!)"
    echo -e "   OptSVGAPlayer target → General → Frameworks"
    echo -e "   Add from Pods:"
    echo -e "   - SVGAPlayer.framework (Do Not Embed)"
    echo -e "   - Protobuf.framework (Do Not Embed)"
    echo -e "   - SSZipArchive.framework (Do Not Embed)\n"

    echo -e "${YELLOW}5. Build Settings:${NC}"
    echo -e "   OptSVGAPlayer target → Build Settings:"
    echo -e "   - Build Libraries for Distribution = YES"
    echo -e "   - Skip Install = NO"
    echo -e "   - Defines Module = YES\n"

    echo -e "${BLUE}========================================${NC}\n"

    read -p "Press Enter when you've completed the manual steps..."
fi

# Step 5: Verify configuration
echo -e "\n${YELLOW}Step 5: Verifying configuration...${NC}"

if ! xcodebuild -workspace Demo/Demo.xcworkspace -list | grep -q "OptSVGAPlayer"; then
    echo -e "${RED}❌ OptSVGAPlayer scheme not found!${NC}"
    echo -e "Please ensure the target was created correctly."
    exit 1
fi
echo -e "${GREEN}✅ OptSVGAPlayer scheme found${NC}"

# Step 6: Offer to build
echo -e "\n${YELLOW}Step 6: Build XCFramework${NC}"
echo -e "Ready to build OptSVGAPlayer.xcframework\n"

read -p "Build now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./Scripts/build_xcframework.sh

    if [ -d "Demo/build/OptSVGAPlayer.xcframework" ]; then
        echo -e "\n${GREEN}========================================${NC}"
        echo -e "${GREEN}✅ Success!${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo -e "\nXCFramework location:"
        echo -e "${BLUE}Demo/build/OptSVGAPlayer.xcframework${NC}\n"
        du -sh Demo/build/OptSVGAPlayer.xcframework
    else
        echo -e "\n${RED}❌ Build failed!${NC}"
        echo -e "Please check the error messages above."
        exit 1
    fi
else
    echo -e "\nYou can build later by running:"
    echo -e "${BLUE}./Scripts/build_xcframework.sh${NC}"
fi

echo -e "\n${GREEN}Setup complete!${NC}"
