# OptSVGAPlayer XCFramework

一个统一的 XCFramework,包含:
- 原版 **SVGAPlayer** (v2.5.8)
- **SVGARePlayer** (重构优化版)
- **SVGAExPlayer** (Swift 增强版)

## 快速开始

### 方式 1: 使用 Ruby 自动化脚本 (推荐)

```bash
# 安装 xcodeproj gem (如果未安装)
gem install xcodeproj

# 运行设置脚本
./Scripts/setup_xcode_target.rb

# 安装 CocoaPods 依赖
cd Demo && pod install && cd ..
```

然后需要在 Xcode 中手动链接框架(见下方详细步骤)。

### 方式 2: 手动配置

详细步骤请查看 [XCFRAMEWORK_SETUP.md](./XCFRAMEWORK_SETUP.md)

## 构建 XCFramework

配置完成后,运行构建脚本:

```bash
./Scripts/build_xcframework.sh
```

构建产物位于: `Demo/build/OptSVGAPlayer.xcframework`

## 手动步骤(自动化脚本后仍需执行)

### 1. 在 Xcode 中链接 Pods 框架

1. 打开 `Demo/Demo.xcworkspace` (必须是 workspace!)
2. 选择 `OptSVGAPlayer` target
3. 进入 **General** → **Frameworks and Libraries**
4. 点击 `+` 添加以下框架:
   - `SVGAPlayer.framework`
   - `Protobuf.framework`
   - `SSZipArchive.framework`
5. 将所有框架的 **Embed** 设置为 **Do Not Embed**

### 2. 验证配置

确认以下设置:

#### Build Settings
- `Build Libraries for Distribution` = YES
- `Skip Install` = NO
- `Defines Module` = YES
- `Swift Version` = 5.0

#### Build Phases
- **Headers** → Public:
  - OptSVGAPlayer.h
  - SVGARePlayer.h
  - SVGAVideoEntity+Extension.h

#### Scheme
确保 `OptSVGAPlayer` scheme 存在并设置为 Shared

## 项目结构

```
SVGAPlayer_Optimized/
├── SVGAPlayer_Optimized/          # 源代码
│   ├── SVGARePlayer.{h,m}
│   ├── SVGAExPlayer.swift
│   └── SVGAVideoEntity+Extension.{h,m}
├── Demo/
│   ├── Demo.xcodeproj
│   ├── Demo.xcworkspace            # ⚠️ 必须使用这个打开!
│   ├── OptSVGAPlayer/              # Framework 文件
│   │   ├── OptSVGAPlayer.h
│   │   └── Info.plist
│   ├── Podfile                     # 已配置 OptSVGAPlayer target
│   └── build/                      # 构建产物(git ignored)
│       └── OptSVGAPlayer.xcframework
└── Scripts/
    ├── setup_xcode_target.rb       # 自动化配置脚本
    └── build_xcframework.sh        # 构建脚本
```

## 使用 XCFramework

### 拖入项目

1. 将 `OptSVGAPlayer.xcframework` 拖入你的项目
2. Target → General → Frameworks and Libraries → **Embed & Sign**

### 代码导入

```swift
import OptSVGAPlayer

// 使用原版 SVGAPlayer
let parser = SVGAParser()

// 使用 SVGARePlayer
let rePlayer = SVGARePlayer()

// 使用 SVGAExPlayer (推荐)
let exPlayer = SVGAExPlayer()
exPlayer.play("animation.svga")
```

```objc
@import OptSVGAPlayer;

// 使用任意组件
SVGAExPlayer *player = [[SVGAExPlayer alloc] init];
```

## 依赖管理

OptSVGAPlayer 依赖于:
- **SVGAPlayer** (v2.5.8) - 包含在 XCFramework 中
- **Protobuf** (3.29.5) - 需要单独添加
- **SSZipArchive** (2.4.3) - 需要单独添加

### CocoaPods 配置示例

```ruby
pod 'OptSVGAPlayer', :path => 'path/to/OptSVGAPlayer.xcframework'
pod 'Protobuf', '3.29.5'
pod 'SSZipArchive', '2.4.3'
```

## 更新上游 SVGAPlayer

```bash
# 修改 Demo/Podfile 中的版本号
# pod 'SVGAPlayer', :git => '...', :tag => '新版本'

cd Demo
pod update SVGAPlayer
cd ..

# 重新构建
./Scripts/build_xcframework.sh
```

## 故障排查

### ❌ Module 'SVGAPlayer' not found

**原因**: 未正确链接 Pods 框架

**解决**:
1. 确保使用 `.xcworkspace` 打开项目
2. 检查 OptSVGAPlayer target 的 Frameworks and Libraries
3. 运行 `pod install`

### ❌ Archive 失败

**原因**: Build settings 配置不正确

**解决**:
1. 检查 `BUILD_LIBRARY_FOR_DISTRIBUTION = YES`
2. 检查 `SKIP_INSTALL = NO`
3. Clean Build Folder (⇧⌘K)

### ❌ Headers not found

**原因**: Headers 未设置为 Public

**解决**: Build Phases → Headers → 将必要的 .h 文件拖到 Public 区域

## 优势

✅ **最小改动**: 只在 Demo 项目中添加 target,不修改现有代码
✅ **易于维护**: 通过 CocoaPods 管理依赖,方便更新
✅ **统一分发**: 一个 XCFramework 包含所有组件
✅ **向后兼容**: 原有 SVGAPlayer API 完全可用

## 许可证

MIT License - 详见 [LICENSE](./LICENSE)

## 相关链接

- [SVGAPlayer-iOS 原版仓库](https://github.com/svga/SVGAPlayer-iOS)
- [SVGAPlayer-iOS Fork (Protobuf 3.29.5)](https://github.com/Rogue24/SVGAPlayer-iOS)
- [项目主 README](./README.md)
