#!/bin/bash
echo "" >> ~/.zshrc
echo '# bun' >> ~/.zshrc
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.zshrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.zshrc
echo "已將 bun 添加到 ~/.zshrc"
echo "請執行 'source ~/.zshrc' 或重啟終端以生效"
