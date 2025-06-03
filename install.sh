#!/bin/bash
echo "Installing Akpo..."
sudo curl -sSL https://raw.githubusercontent.com/$GITHUB_REPOSITORY_OWNER/akpo/main/bin/akpo \
  -o /usr/local/bin/akpo
sudo chmod +x /usr/local/bin/akpo
echo "✅ Installed! Run 'akpo scan' in any project."