# 🚀 OptSVGAPlayer XCFramework - 快速开始

## 仅需 2 步完成!

### ✅ 已自动完成
- Framework target 创建 ✓
- 源文件添加 ✓
- Build Settings 配置 ✓
- CocoaPods 安装 ✓

### 📋 你需要做的 (2 分钟)

#### 第 1 步: 链接框架 (在 Xcode 中)

1. 打开 `Demo/Demo.xcworkspace`
2. 选择 `OptSVGAPlayer` target → General
3. Frameworks and Libraries → 点击 `+` → 添加:
   - SVGAPlayer.framework (Do Not Embed)
   - Protobuf.framework (Do Not Embed)
   - SSZipArchive.framework (Do Not Embed)

#### 第 2 步: 构建 (在终端中)

```bash
./Scripts/build_xcframework.sh
```

完成！XCFramework 位于: `Demo/build/OptSVGAPlayer.xcframework`

---

## 详细文档

- [完整设置指南](./NEXT_STEPS.md)
- [详细配置说明](./XCFRAMEWORK_SETUP.md)
- [XCFramework 使用文档](./README_XCFRAMEWORK.md)

## 需要帮助?

检查 `NEXT_STEPS.md` 中的故障排查部分
