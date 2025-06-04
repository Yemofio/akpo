#!/bin/bash

run_scan() {
    echo "🔍 Running Python Security Scan..."
    
    # Semgrep with custom rules
    semgrep --config=/rules/python/security.yml --json -o /results/semgrep.json
    
    # Bandit (general Python SAST)
    bandit -r . -f json -o /results/bandit.json
    
    # Safety (dependency checks)
    safety check --json > /results/safety.json
    
    echo "✅ Scan completed!"
}

run_js_scan() {
    echo "🔍 Running JavaScript Security Scan..."

    # Check if .akpo-results directory exists
    if [ ! -d ".akpo-results" ]; then
        mkdir .akpo-results
    fi


    # ESLint with security rules
    echo "🔎 Running ESLint..."
    npx eslint . --ext .js,.jsx,.ts --format json --output-file .akpo-results/eslint.json
    echo "✅ ESLint completed! $?"

     # Check if eslint.json file was created
    if [ ! -f ".akpo-results/eslint.json" ]; then
        echo "Error: eslint.json file was not created"
    fi

    # npm audit (dependency checks)
    if [ -f "package.json" ]; then
        echo "🔎 Running npm audit..."
        npm audit --json > .akpo-results/npm-audit.json
        echo "✅ npm audit completed! $?"
    fi
    
    # Gitleaks (secrets)
    echo "🔎 Running Gitleaks..."
    gitleaks detect --source=. --report-path=.akpo-results/gitleaks.json
    echo "✅ Gitleaks completed! $?"
}

case "$1" in
    scan)
        if [ -f "package.json" ]; then
            run_js_scan
        elif [ -f "requirements.txt" ]; then
            run_scan
        else
            run_js_scan
            echo "⚠️ No supported project type detected"
            echo "📊 Results saved to /results"
            # touch /results/eslint.json
            # exit 0
        fi
        ;;
    *) echo "Usage: $0 [scan]"; exit 1 ;;
esac