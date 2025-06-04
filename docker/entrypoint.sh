#!/bin/bash

# Initialize tool options
SEMGREP_OPTIONS="--json"
BANDIT_OPTIONS="-f json"
NPM_AUDIT_OPTIONS="--json"
GITLEAKS_OPTIONS="--redact"

# Enable strict mode if requested
if [[ "$*" == *"--strict"* ]]; then
    echo "🛡️ Running in STRICT mode (will fail on warnings)"
    SEMGREP_OPTIONS+=" --error"
    BANDIT_OPTIONS="-lll"  # Show low+ severity findings
    NPM_AUDIT_OPTIONS+=" --audit-level=moderate"
    GITLEAKS_OPTIONS+=" --exit-code=1"
fi

run_scan() {
    echo "🔍 Running Python Security Scan..."
    semgrep scan --config=/rules/python/security.yml $SEMGREP_OPTIONS -o /results/semgrep.json
    bandit -r . $BANDIT_OPTIONS -o /results/bandit.json
    safety check --json > /results/safety.json
}

run_js_scan() {
    echo "🔍 Running JavaScript Security Scan..."
    eslint --no-eslintrc --rule 'security/detect-object-injection: error' \
           -f json -o /results/eslint.json .
    if [ -f "package.json" ]; then
        npm audit $NPM_AUDIT_OPTIONS > /results/npm-audit.json
    fi
    gitleaks detect --source=. $GITLEAKS_OPTIONS --report-path=/results/gitleaks.json
}

case "$1" in
    scan)
        shift  # Remove 'scan' from arguments
        if [ -f "package.json" ]; then
            run_js_scan "$@"
        elif [ -f "requirements.txt" ]; then
            run_python_scan "$@"
        else
            echo "⚠️ No supported project type detected"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 scan [--strict]"
        exit 1
        ;;
esac

# Propagate failure in strict mode
if [[ "$*" == *"--strict"* ]] && [ -f "/results/gitleaks.json" ]; then
    if jq -e '.findings | length > 0' /results/gitleaks.json >/dev/null; then
        echo "❌ Gitleaks found secrets - failing strict mode!"
        exit 1
    fi
fi