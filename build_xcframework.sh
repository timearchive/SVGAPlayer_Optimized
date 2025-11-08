#!/bin/bash

# OptSVGAPlayer XCFramework 构建脚本
# 使用方法: bash build_xcframework.sh

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================"
echo "构建 OptSVGAPlayer.xcframework"
echo -e "========================================${NC}"

# 配置
WORKSPACE="Demo/Demo.xcworkspace"
SCHEME="OptSVGAPlayer"
BUILD_DIR="build"
XCFRAMEWORK_NAME="OptSVGAPlayer.xcframework"

# 清理
echo -e "${YELLOW}🧹 清理旧构建...${NC}"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

# 构建真机版本
echo -e "${YELLOW}📱 构建真机版本 (arm64)...${NC}"
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -destination "generic/platform=iOS" \
  -archivePath "${BUILD_DIR}/${SCHEME}-iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  ONLY_ACTIVE_ARCH=NO \
  ARCHS="arm64" \
  VALID_ARCHS="arm64" \
  -skipMacroValidation \
  EXCLUDED_SOURCE_FILE_NAMES="*-dynamic*" \
  2>&1 | grep -v "umbrella header" | grep -v "frameInterval" | grep -v "search path.*not found" | grep -v "appintentsmetadataprocessor" | grep -v "unsandboxed script phases" | grep -v "does not specify any outputs" | grep -E "error:|^\*\* BUILD|succeeded|failed|Compiling|Linking" || true

# 检查真机构建是否成功
if [ ! -d "${BUILD_DIR}/${SCHEME}-iOS.xcarchive" ]; then
  echo -e "${RED}❌ 真机版本构建失败！${NC}"
  echo "请检查详细日志: xcodebuild archive ... 2>&1 | tee ios_build.log"
  exit 1
fi
echo -e "${GREEN}✅ 真机版本构建成功${NC}"

# 构建模拟器版本
echo -e "${YELLOW}🖥  构建模拟器版本 (arm64)...${NC}"
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
  2>&1 | grep -v "umbrella header" | grep -v "frameInterval" | grep -v "search path.*not found" | grep -v "appintentsmetadataprocessor" | grep -v "unsandboxed script phases" | grep -v "does not specify any outputs" | grep -E "error:|^\*\* BUILD|succeeded|failed|Compiling|Linking" || true

# 检查模拟器构建是否成功
if [ ! -d "${BUILD_DIR}/${SCHEME}-Simulator.xcarchive" ]; then
  echo -e "${RED}❌ 模拟器版本构建失败！${NC}"
  echo "请检查详细日志: xcodebuild archive ... 2>&1 | tee simulator_build.log"
  exit 1
fi
echo -e "${GREEN}✅ 模拟器版本构建成功${NC}"

# 创建 XCFramework
echo -e "${YELLOW}📦 创建 XCFramework...${NC}"
xcodebuild -create-xcframework \
  -framework "${BUILD_DIR}/${SCHEME}-iOS.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -framework "${BUILD_DIR}/${SCHEME}-Simulator.xcarchive/Products/Library/Frameworks/${SCHEME}.framework" \
  -output "${BUILD_DIR}/${XCFRAMEWORK_NAME}" \
  2>&1 | grep -v "xcframework successfully written" || true

# 验证结果
if [ -f "${BUILD_DIR}/${XCFRAMEWORK_NAME}/Info.plist" ]; then
  echo -e "${GREEN}========================================${NC}"
  echo -e "${GREEN}✅ XCFramework 构建成功！${NC}"
  echo -e "${GREEN}========================================${NC}"
  echo ""
  echo "位置: $(pwd)/${BUILD_DIR}/${XCFRAMEWORK_NAME}"
  echo ""
  echo "大小:"
  du -sh "${BUILD_DIR}/${XCFRAMEWORK_NAME}"
  echo ""
  echo "二进制文件:"
  ls -lh "${BUILD_DIR}/${XCFRAMEWORK_NAME}/ios-arm64/${SCHEME}.framework/${SCHEME}" | awk '{print "  真机: " $5}'
  ls -lh "${BUILD_DIR}/${XCFRAMEWORK_NAME}/ios-arm64-simulator/${SCHEME}.framework/${SCHEME}" | awk '{print "  模拟器: " $5}'
  echo ""
  echo "头文件数量:"
  ls "${BUILD_DIR}/${XCFRAMEWORK_NAME}/ios-arm64/${SCHEME}.framework/Headers/" | wc -l | tr -d ' ' | xargs -I {} echo "  {} 个"
  echo ""
else
  echo -e "${RED}❌ XCFramework 创建失败！${NC}"
  exit 1
fi
