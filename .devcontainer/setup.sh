#!/bin/bash
echo "🚀 Setting up Akpo development environment..."

# Install core system tools
sudo apt-get update && sudo apt-get install -y \
    jq unzip python3-pip npm curl git docker.io

# Install language-specific scanners
pip install bandit safety semgrep pip-audit checkov
npm install -g @npmcli/arborist
curl -sSfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh
curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/install.sh | sh

# Create project structure
mkdir -p \
    bin \
    rules/{python,javascript,golang} \
    docker \
    examples/{python-app,nodejs-app,golang-app}

echo "✅ Setup complete! Project structure ready."