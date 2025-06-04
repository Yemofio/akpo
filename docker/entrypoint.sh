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

case "$1" in
    scan) run_scan ;;
    *) echo "Usage: $0 [scan]"; exit 1 ;;
esac