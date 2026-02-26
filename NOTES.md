# OpenCode Development Notes

## 修复 bun 环境变量 (2025-02-26)

**问题描述**
在执行 `git push` 时，`pre-push` hook 失败，提示 `bun: command not found`。
这是因为 `bun` 虽然已安装，但未添加到系统的 PATH 环境变量中。

**解决方案**
1.  **升级 bun**: 将本地/全局 bun 升级到最新版本 (v1.3.9)。
    ```bash
    ~/.bun/bin/bun upgrade
    ```
2.  **配置 PATH**: 将 bun 的安装路径添加到 `.zshrc`。
    ```bash
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    ```
3.  **生效配置**:
    ```bash
    source ~/.zshrc
    ```

**相关脚本**
已创建辅助脚本 `setup_bun.sh` 自动完成上述配置。

## Bun 介绍与使用 (2025-02-26)

**Bun 是什么？**
Bun 是一个专为速度打造的現代 JavaScript 運行時 (Runtime)，它集成了多種開發工具，旨在替換 Node.js。
- **Runtime**: 可以直接執行 `.js`、`.ts`、`.jsx`、`.tsx` 文件。
- **Package Manager**: 兼容 npm 的包管理器 (`bun install`)，速度極快。
- **Bundler**: 內建打包工具 (類似 Webpack/Vite)。
- **Test Runner**: 內建測試框架 (`bun test`)，兼容 Jest。

**常用指令**
- `bun run <script>`: 執行 package.json 中的腳本 (可省略 run，如 `bun dev`)。
- `bun install`: 安裝依賴 (會產生 `bun.lockb`)。
- `bun add <package>`: 安裝套件。
- `bun test`: 執行測試。
- `bun <file.ts>`: 直接執行 TypeScript 文件。

**在 OpenCode 中的應用**
本專案使用 Bun 作為主要的運行時與包管理器。
- **啟動開發**: `./bun dev`
- **安裝依賴**: `./bun install`
- **類型檢查**: `./bun typecheck` (作為 pre-push hook)

## Runtime (运行时) 概念解析 (2025-02-26)

**什么是 Runtime？**
Runtime (运行时) 是程序代码实际运行的**环境**。如果说代码是「剧本」，Runtime 就是「舞台」和「演员」。代码必须在 Runtime 中才能“活”过来。

**JavaScript Runtime 的演变**
JavaScript 代码本身只是纯文本，需要 Runtime 提供解析引擎和 API 支持。
1.  **浏览器 (Browser)**: 最早的 JS Runtime。
    -   **能力**: 操作网页 DOM (`document`)、弹窗 (`alert`)。
    -   **限制**: 为了安全，不能读写本地文件，不能启动服务器。
2.  **Node.js**: 2009年诞生，将 JS 带到了服务器端。
    -   **能力**: 读写文件 (`fs`)、网络通信 (`http`)、操作系统交互。
    -   **移除**: 没有 DOM (因為沒有瀏覽器視窗)。
3.  **Bun / Deno**: 新一代 Runtime。
    -   **目标**: 更快、更安全、开发体验更好（原生支持 TypeScript）。

**Runtime 的核心职责**
- **解析与编译**: 把人类写的代码翻译成机器能懂的指令 (例如通过 V8 引擎)。
- **提供 API**: 给代码提供操作系统的能力 (如「读取文件」、「发送网络请求」)。
- **内存管理**: 自动分配和回收内存 (Garbage Collection)。
