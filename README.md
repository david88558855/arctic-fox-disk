<div align="center">

<img src="./app/assets/icon/icon.png" width="132" alt="Arctic Fox Disk" />

# 白狐云盘 · Arctic Fox Disk

**一个把 16 种云存储装进同一个界面的跨平台文件管理器。**

Flutter 客户端 + 内嵌 Go 服务端，无需部署、无需公网、无需账号体系。

[![License](https://img.shields.io/badge/License-GPL--3.0-4C6FFF.svg)](./LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.29.3-54C5F8.svg)](https://flutter.dev)
[![Go](https://img.shields.io/badge/Go-1.26-00ADD8.svg)](https://go.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-16202C.svg)](#平台支持)

</div>

---

## 这是什么

白狐云盘是一个**无服务端**的多协议云盘客户端。

传统网盘工具要么只能连一家厂商，要么需要你在服务器上跑一个中转服务。白狐云盘把这两件事都省了：**Go 编写的中转服务直接编译进 App 里**（Android 走 `gomobile` AAR，iOS 走 `xcframework`，桌面走 `c-shared` 动态库，由 Dart FFI 加载），通过本机 gRPC 与界面通信。你的账号密码、文件内容、访问凭证都只留在设备上。

所以它同时具备两种形态：

- **对普通用户**：一个 App，登录多个网盘，像用本地文件管理器一样在它们之间复制、移动、预览。
- **对开发者**：一份 Flutter + Go 的完整参考实现，展示如何用 gRPC 把多协议存储抽象成统一文件树。

---

## 核心能力

### 一、多协议存储，一套文件树

16 种后端共用同一套「目录 / 文件 / 任务」模型。切换存储对界面完全透明——同样的列表、同样的右键菜单、同样的拖拽。

### 二、文件操作，与本地一致

上传、下载、新建目录、重命名、复制、移动、删除、批量选择。跨存储复制与移动由服务端在两个协议之间流式转发，不落临时文件。

### 三、预览，不用下载

图片、视频、音频、纯文本与源码五类原地预览。视频支持进度拖动与倍速，图片支持缩放与手势，文本支持行号与语法着色的源码视图。

### 四、传输任务，可控可续

所有上传下载进入统一任务队列，分「正在进行 / 已完成 / 已失败」三态。进度实时刷新，支持暂停、继续、重试与批量清理。并发数与分片大小可调，弱网下可限制为「仅 Wi-Fi」。

### 五、存储治理，四个开关解决四类麻烦

| 能力 | 解决什么 | 行为 |
|---|---|---|
| 加密 | 不想让云厂商看到内容 | 上传前本地加密，读取时本地解密 |
| 压缩 | 小文件多、传输慢 | 上传前打包，下载后自动解包 |
| 限速 | 抢占带宽影响别人 | 按存储单独设定上下行速率上限 |
| 回收站 | 误删 | 删除先进 `.arcticfoxrecycle`，可还原或彻底清除 |

另有缩略图缓存与本地缓存策略，控制磁盘占用。

### 六、界面，克制的浅色系统

固定的单一浅色主题，主色 `#4C6FFF`，圆角与阴影收敛成 6 档令牌，所有页面共用同一套卡片语言。**没有主题切换**——减少一个需要维护的维度，界面永远是可预期的那一张。

品牌标识是一只朝左坐着的白狐：一条闭合路径、96 段三次贝塞尔、纯剪影、无描边，可在 24px 到 1024px 之间任意缩放而不用换图。

---

## 支持的存储

| 类别 | 协议 / 服务 |
|---|---|
| 本地与自建 | 本地磁盘、WebDAV、SFTP、SMB、FTP |
| 对象存储 | Amazon S3（含兼容实现）、又拍云 |
| 商业网盘 | OneDrive、Google Drive、115 网盘、夸克网盘 |
| 开发者向 | GitHub 仓库、GitHub Release、AList、Foxel、Mirror |
| 聚合挂载 | 任意上述协议再组合（如 S3 挂到 WebDAV 下） |

每种存储可单独开关、单独配置高级项（加密 / 压缩 / 限速 / 回收站 / 缓存），互不影响。

---

## 架构

```
┌──────────────────────────────────────────────┐
│  Flutter UI（6 端）                           │
│  Riverpod 状态 · 令牌化设计系统 · 文件树视图    │
└───────────────────┬──────────────────────────┘
                    │ gRPC（本机回环 / unix socket）
┌───────────────────▼──────────────────────────┐
│  Go Server（内嵌，无独立进程可部署）            │
│  文件抽象层 · 任务调度 · 加密/压缩/限速/回收站   │
└───────────────────┬──────────────────────────┘
                    │ 各协议 SDK
┌───────────────────▼──────────────────────────┐
│  S3 · WebDAV · SFTP · SMB · FTP · OneDrive …  │
└──────────────────────────────────────────────┘
```

关键点：**服务端不是另一个部署单元**。它在构建期被编译成平台原生库（`libserver.aar` / `libserver.xcframework` / `libserver.dylib` / `libserver.dll`），随 App 一起分发，启动时由客户端拉起并监听本机端口。

---

## 快速开始

### 环境

| 依赖 | 版本 | 说明 |
|---|---|---|
| Flutter | 3.29.3 | 与 `app/.fvmrc` 一致 |
| Dart | 3.x | 随 Flutter |
| Go | 1.26+ | 编译内嵌服务端 |
| JDK | 17 | Android 构建 |
| Android SDK / NDK | API 21+ / 26.x | `gomobile` 需要 |

### 1. 先编译服务端产物

这一步不能跳。Gradle / Xcode 会去找 `libserver`，仓库里不放这个二进制。

```bash
# Android：生成 AAR
mkdir -p app/android/app/libs
cd server
go install golang.org/x/mobile/cmd/gomobile@latest
go get golang.org/x/mobile/bind
gomobile init
gomobile bind \
  -ldflags="-w -s -X github.com/david88558855/arctic-fox-disk/server/internal/app.VERSION=dev" \
  -o ../app/android/app/libs/libserver.aar \
  -target=android -androidapi 21 \
  -javapkg="com.arcticfox.disk" \
  github.com/david88558855/arctic-fox-disk/server/cmd/mobile
```

iOS 用 `-target=ios -o ../app/ios/Frameworks/libserver.xcframework`；
桌面端用 `go build -buildmode=c-shared -o libserver.dylib|.dll ./server/cmd/desktop`。

### 2. 生成 Dart 代码

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

`*.g.dart` / `*.freezed.dart` 不入库，每次构建都要重新生成。

### 3. 运行

```bash
flutter run                    # 当前连接的设备
flutter build apk --debug      # Android
flutter build macos            # macOS
flutter build windows          # Windows
```

---

## 平台支持

| 平台 | 状态 | 服务端形态 |
|---|---|---|
| Android | ✅ | `libserver.aar`（gomobile） |
| iOS | ✅ | `libserver.xcframework`（gomobile） |
| macOS | ✅ | `libserver.dylib`（c-shared） |
| Windows | ✅ | `libserver.dll`（c-shared） |
| Linux | ✅ | 与 Windows 同构 |
| Web | ⚠️ | 无本地服务端，仅界面与远程 gRPC |

---

## 项目结构

```
arctic-fox-disk/
├── app/                    Flutter 客户端
│   ├── lib/
│   │   ├── app/            启动、路由、i18n、gRPC 桥
│   │   ├── common/         主题令牌、通用组件、工具
│   │   │   ├── theme/      design_tokens.dart · mp_theme.dart
│   │   │   └── widgets/    brand_mark.dart · surface_card.dart …
│   │   ├── api/
│   │   │   ├── file/       文件列表、预览、存储库、16 种协议表单
│   │   │   ├── task/       任务队列
│   │   │   ├── home/       主框架、关于、帮助
│   │   │   └── setting/    设置、语言、备份
│   │   └── generated/      protobuf / ffigen 产物（入库）
│   ├── android/ ios/ macos/ windows/ linux/ web/
│   └── assets/icon/        品牌图标
├── server/                 Go 服务端（内嵌）
│   ├── cmd/                mobile（gomobile）· desktop（c-shared）
│   └── internal/           协议实现、任务、存储抽象
├── proto/                  gRPC 接口定义
└── .github/workflows/      ci.yml · build-apk.yml · release.yml
```

---

## 设计系统

改版后的界面由一层薄薄的令牌驱动，改一处即全站生效。

```dart
// app/lib/common/theme/design_tokens.dart
MPColor.primary        // #4C6FFF  主按钮 / 选中 / 进度
MPColor.ink / ink2 / ink3   // 三级文字
MPColor.bg / surface / border
MPRadius.r8 … r18 / pill     // 五档，不新增第六档
MPShadow.card / float / sheet
MPType.pageTitle … label     // 六级字阶
```

主题固定为浅色（`MPTheme.light()`），深色系统下仍返回同一套，不给用户切换入口。
两个自带收口点让一致性无需逐页维护：

- `ColorUtil.scaffoldBackgroundColor()` —— 23 处页面底色
- `CustomListSection` —— 36 个设置类页面的分组卡

改这两个，全站底色与卡片圆角同时对齐。

---

## 开发

```bash
cd app
flutter analyze                # 静态检查
dart format lib                # 格式化
dart run build_runner watch    # 模型变更时持续生成
```

CI（GitHub Actions）：

| workflow | 触发 | 做什么 |
|---|---|---|
| `ci.yml` | push / PR | `pub get` → `build_runner` → `flutter analyze`（基线历史 issue 白名单，只拦新增 error） |
| `build-apk.yml` | 手动 | gomobile 编 AAR → 构建 debug APK 并上传产物 |
| `release.yml` | release / 手动 | 六端完整发布构建 |

上游基线自带 143 条历史 lint 问题（集中在 `lib/generated/**`），因此 `analysis_options.yaml` 排除了生成代码目录，CI 门禁只对**新增**错误生效。

---

## 许可证与来源

本项目以 **GPL-3.0** 发布，`LICENSE` 全文保持原样。

它源自 [honmaple/maple-file](https://github.com/honmaple/maple-file) v1.2.0：沿用其多协议存储实现与 gRPC 架构，在此基础上完成**品牌更名**与**界面重构**（配色体系、布局、图标、单一主题收敛），不改变原有功能范围、协议与数据格式。

原始版权归 honmaple 及上游贡献者所有；本仓库的界面与品牌部分由 Arctic Fox Disk 维护者贡献。分发衍生版本时请同样保留 `LICENSE` 与本节署名。
