# OptSVGAPlayer XCFramework 构建指南

本指南说明如何完成 OptSVGAPlayer.xcframework 的构建配置。

## 已完成的准备工作

✅ 创建了 `Demo/OptSVGAPlayer/` 目录及必要文件
✅ 创建了 `OptSVGAPlayer.h` umbrella header
✅ 修改了 `Demo/Podfile` 添加 OptSVGAPlayer target
✅ 创建了构建脚本 `Scripts/build_xcframework.sh`
✅ 更新了 `.gitignore`

## 需要手动完成的步骤

### 1. 在 Xcode 中创建 Framework Target

1. 打开 `Demo/Demo.xcodeproj`
2. 选择项目 → 点击底部 `+` 按钮 → 选择 `Framework`
3. 配置新 target:
   - **Product Name**: `OptSVGAPlayer`
   - **Team**: (选择你的开发团队)
   - **Organization Identifier**: `com.yourdomain` (或使用现有的)
   - **Language**: Objective-C
   - **Include Tests**: 不勾选

4. 创建完成后，删除自动生成的 `OptSVGAPlayer.h` 文件(使用我们已经创建的版本)

### 2. 配置 OptSVGAPlayer Target

#### 2.1 General 设置
- **Deployment Target**: iOS 12.0
- **Frameworks and Libraries**: (稍后通过 CocoaPods 配置)

#### 2.2 Build Settings 关键配置
在 OptSVGAPlayer target 的 Build Settings 中设置:

```
Build Libraries for Distribution = YES
Skip Install = NO
Defines Module = YES
```

#### 2.3 添加源文件到 Target

在项目导航器中,将以下文件添加到 OptSVGAPlayer target:

**从 `../SVGAPlayer_Optimized/` 添加:**
- `SVGARePlayer.h` (设置为 Public)
- `SVGARePlayer.m`
- `SVGAExPlayer.swift`
- `SVGAVideoEntity+Extension.h` (设置为 Public)
- `SVGAVideoEntity+Extension.m`

**从 `Demo/OptSVGAPlayer/` 添加:**
- `OptSVGAPlayer.h` (设置为 Public - 这是 umbrella header)
- `Info.plist`

#### 2.4 配置 Headers

1. 选择 OptSVGAPlayer target → Build Phases → Headers
2. 将以下 header 拖到 **Public** 区域:
   - `OptSVGAPlayer.h`
   - `SVGARePlayer.h`
   - `SVGAVideoEntity+Extension.h`

### 3. 运行 CocoaPods

```bash
cd Demo
pod install
```

这会为 OptSVGAPlayer target 安装 SVGAPlayer 依赖。

### 4. 在 Xcode 中链接依赖框架

1. 打开 `Demo/Demo.xcworkspace` (注意是 workspace,不是 xcodeproj!)
2. 选择 OptSVGAPlayer target → General → Frameworks and Libraries
3. 点击 `+` 添加以下框架:
   - `SVGAPlayer.framework` (从 Pods 中)
   - `Protobuf.framework` (从 Pods 中)
   - `SSZipArchive.framework` (从 Pods 中)
4. 将这些框架的 Embed 设置为 **Do Not Embed**

### 5. 创建 Scheme

1. 在 Xcode 中,选择菜单 Product → Scheme → Manage Schemes
2. 确保 `OptSVGAPlayer` scheme 存在并勾选 **Shared**
3. 编辑 scheme:
   - Build → 确保 OptSVGAPlayer 被勾选
   - Archive → Build Configuration 设置为 **Release**

### 6. 构建 XCFramework

完成以上配置后,在项目根目录运行:

```bash
./Scripts/build_xcframework.sh
```

如果没有安装 `xcpretty`,可以先安装:

```bash
gem install xcpretty
```

或者修改脚本删除 `| xcpretty` 部分。

## 构建产物

成功构建后,XCFramework 将位于:
```
Demo/build/OptSVGAPlayer.xcframework
```

## 使用 XCFramework

### 方式 1: 直接拖入项目

1. 将 `OptSVGAPlayer.xcframework` 拖入你的项目
2. 在 target → General → Frameworks and Libraries 中设置为 **Embed & Sign**

### 方式 2: 通过 CocoaPods

创建新的 podspec:

```ruby
Pod::Spec.new do |s|
  s.name         = 'OptSVGAPlayer'
  s.version      = '1.0.0'
  s.summary      = 'Unified SVGA Player Framework'
  s.homepage     = 'https://github.com/yourname/SVGAPlayer_Optimized'
  s.license      = 'MIT'
  s.author       = { 'Your Name' => 'email@example.com' }
  s.source       = { :git => 'https://github.com/yourname/SVGAPlayer_Optimized.git', :tag => s.version }

  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = 'OptSVGAPlayer.xcframework'
end
```

## 注意事项

1. **依赖传递**: OptSVGAPlayer.xcframework 本身不包含 SVGAPlayer 及其依赖,使用时需要确保这些依赖可用
2. **Swift 版本**: 确保使用 Swift 5.0+
3. **Xcode 版本**: 建议使用 Xcode 14.0+

## 故障排查

### 问题: Archive 失败,提示找不到 SVGAPlayer

**解决**: 确保在 workspace 中打开项目,而不是单独的 xcodeproj

### 问题: 链接错误

**解决**: 检查 Build Phases → Link Binary With Libraries 是否正确添加了所有 Pods 框架

### 问题: Swift 编译错误

**解决**: 在 Build Settings 中设置 `Swift Language Version = 5.0`

## 更新 SVGAPlayer

要更新到新版本的 SVGAPlayer:

1. 修改 `Demo/Podfile` 中的 tag
2. 运行 `pod update SVGAPlayer`
3. 重新构建 XCFramework

---

**注**: 这个方案的优势是改动最小,所有依赖通过 CocoaPods 管理,便于后续维护和更新。
