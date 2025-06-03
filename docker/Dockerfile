FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3-pip npm
RUN pip install semgrep bandit && npm install -g @npmcli/arborist
COPY bin/akpo-scan /akpo-scan
ENTRYPOINT ["/akpo-scan"]