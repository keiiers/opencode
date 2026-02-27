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

## Git 远程仓库与权限 (2025-02-26)

**推送去哪里？**
- `origin` (您的仓库): `https://github.com/keiiers/opencode.git`
- `upstream` (官方仓库): `https://github.com/anomalyco/opencode.git`

**权限控制**
- 您對 `origin` 有完整的**讀寫權限** (Push & Pull)。
- 您對 `upstream` 通常只有**讀取權限** (Pull only)，無法直接推送。

**如何贡献代码？**
如果您希望將代碼貢獻給官方，必須通過 **Pull Request (PR)** 流程：
1.  推送到您的 `origin`。
2.  在 GitHub 介面上發起 PR 請求合併到 `upstream`。
3.  官方審核通過後才會合併。

**隐私安全**
只要不發起包含私人文件的 PR，您的 `NOTES.md` 就只會存在於您的電腦和您的 GitHub (`origin`) 上，官方倉庫不會有這份文件。

## Git 錯誤修復與合併指南 (2025-02-27)

**1. 誤合併修復 (Reset)**
如果您不小心合併了錯誤的分支（例如選到了開發中的功能分支），可以使用 Reset 功能「時光倒流」：
- **指令修復 (推薦)**: 在終端機執行 `git reset --hard origin/dev`。這會強制將進度重置到遠端 `origin/dev` 的乾淨狀態。
- **圖形修復**: 如果右鍵選單找不到 Reset 選項，請確認是否點擊到了「文字訊息」或「圓點」，而不是「標籤」。

**2. 正確的合併流程 (Merge)**
當需要更新官方代碼時，請遵循以下步驟：
- **更新圖表**: 點擊右上角的 🔄 (Fetch) 按鈕。
- **合併按鈕**: 點擊右上角的 ⭃ (Merge) 按鈕。
- **選擇目標**: 在選單中搜尋並選擇 `upstream/dev` (官方主分支)。
- **確認**: 觀察圖表，確保 `dev` 標籤與 `upstream/dev` 連接在一起。

## 推送失敗排查 (2025-02-27)

**問題描述**
在執行 `git push` 時報錯 `bun: command not found`，即使已經更新了 `bun`。

**原因**
Git 的 `pre-push` 鉤子腳本是在一個**非交互式 shell** (non-interactive shell) 中運行的。
雖然我們在 `.zshrc` 中設定了 PATH，但這個設定可能只在**交互式**終端（你打開的那個黑框框）裡生效。當 Git 在後台執行腳本時，它可能讀不到這個 PATH 設定，導致找不到 `bun`。

**解決方案**
1.  **永久修復**: 我們修改了 `.husky/pre-push` 腳本，在腳本開頭手動添加了 `bun` 的路徑：
    ```bash
    #!/bin/sh
    # Add Bun to PATH for non-interactive shells
    export PATH="$HOME/.bun/bin:$PATH"
    ```
2.  **臨時修復**: 通過指令強制傳遞 PATH：
    ```bash
    export PATH=$HOME/.bun/bin:$PATH && bun -v && git push origin dev
    ```
