FROM ubuntu:22.04

# Install core tools
RUN apt-get update && apt-get install -y \
    python3-pip npm curl jq git && \
    rm -rf /var/lib/apt/lists/*

# Install Python scanners
RUN pip install semgrep bandit safety

# Install entrypoint
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy rules
COPY rules /rules

WORKDIR /target
ENTRYPOINT ["/entrypoint.sh"]

# Install JavaScript tools
RUN npm install -g @npmcli/arborist eslint eslint-plugin-security

# Install Gitleaks (secrets scanning)
RUN curl -sSfL https://raw.githubusercontent.com/gitleaks/gitleaks/master/install.sh | sh

# Copy JS rules
COPY rules/javascript /rules/javascript