# ✅ 自动化设置已完成！

## 已完成的工作

✅ 创建了 `OptSVGAPlayer` Framework target
✅ 添加了所有源文件到 target
✅ 配置了 Public Headers
✅ 设置了 Build Settings
✅ 修改了 Podfile
✅ 运行了 `pod install`
✅ 创建了构建脚本

## 剩余的手动步骤 (仅需 2 分钟)

### 步骤 1: 在 Xcode 中链接 Pods 框架

1. 打开 **Demo/Demo.xcworkspace** (⚠️ 必须是 workspace!)

2. 在项目导航器中,选择 `OptSVGAPlayer` target

3. 点击 **General** 标签

4. 滚动到 **Frameworks and Libraries** 部分

5. 点击 `+` 按钮,添加以下三个框架:
   - `SVGAPlayer.framework`
   - `Protobuf.framework`
   - `SSZipArchive.framework`

6. 对于每个框架,将右侧的 **Embed** 下拉菜单设置为 **Do Not Embed**

截图示例:
```
Frameworks and Libraries
├─ SVGAPlayer.framework          [Do Not Embed]
├─ Protobuf.framework             [Do Not Embed]
└─ SSZipArchive.framework         [Do Not Embed]
```

### 步骤 2: 构建 XCFramework

完成上述步骤后,在终端运行:

```bash
./Scripts/build_xcframework.sh
```

构建产物将位于:
```
Demo/build/OptSVGAPlayer.xcframework
```

## 验证配置

在 Xcode 中,选择 OptSVGAPlayer target,检查以下设置:

### Build Settings
- `Build Libraries for Distribution` = **YES** ✅
- `Skip Install` = **NO** ✅
- `Defines Module` = **YES** ✅
- `Swift Version` = **5.0** ✅

### Build Phases → Headers
Public Headers 应包含:
- ✅ OptSVGAPlayer.h
- ✅ SVGARePlayer.h
- ✅ SVGAVideoEntity+Extension.h

### Build Phases → Compile Sources
应包含:
- ✅ SVGARePlayer.m
- ✅ SVGAExPlayer.swift
- ✅ SVGAVideoEntity+Extension.m

## 故障排查

### 问题: 找不到 Pods 框架

**原因**: 没有使用 workspace 打开项目

**解决**: 确保打开的是 `Demo.xcworkspace`,不是 `Demo.xcodeproj`

### 问题: 编译错误 "Module 'SVGAPlayer' not found"

**原因**: 没有正确链接 Pods 框架

**解决**:
1. 检查 General → Frameworks and Libraries
2. 确保三个框架都已添加
3. Clean Build Folder (⇧⌘K)
4. 重新构建

### 问题: Swift 编译错误

**原因**: Swift 版本配置不正确

**解决**: Build Settings → Swift Language Version = 5.0

## 构建选项

### 标准构建
```bash
./Scripts/build_xcframework.sh
```

### 清理后构建
```bash
rm -rf Demo/build
./Scripts/build_xcframework.sh
```

### 查看详细输出 (如果未安装 xcpretty)
编辑 `Scripts/build_xcframework.sh`,删除所有的 `| xcpretty`

## 使用 XCFramework

构建完成后,你可以:

### 1. 直接使用
将 `OptSVGAPlayer.xcframework` 拖入你的项目

### 2. 创建 CocoaPods 规范
```ruby
Pod::Spec.new do |s|
  s.name         = 'OptSVGAPlayer'
  s.version      = '1.0.0'
  s.vendored_frameworks = 'OptSVGAPlayer.xcframework'

  s.dependency 'Protobuf', '3.29.5'
  s.dependency 'SSZipArchive', '2.4.3'
end
```

### 3. 分发给团队
压缩 XCFramework:
```bash
cd Demo/build
zip -r OptSVGAPlayer.xcframework.zip OptSVGAPlayer.xcframework
```

## 后续更新

### 更新 SVGAPlayer 版本
1. 修改 `Demo/Podfile` 中的 tag
2. 运行 `cd Demo && pod update SVGAPlayer`
3. 重新构建 XCFramework

### 修改 SVGARePlayer 或 SVGAExPlayer
1. 编辑 `SVGAPlayer_Optimized/` 中的源文件
2. 重新构建 XCFramework

---

**需要帮助?** 查看 [XCFRAMEWORK_SETUP.md](./XCFRAMEWORK_SETUP.md) 了解详细文档
