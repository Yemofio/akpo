FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3-pip npm curl
RUN pip install semgrep bandit && npm install -g @npmcli/arborist
COPY bin/akpo /akpo
RUN chmod +x /akpo
ENTRYPOINT ["/akpo"]
ENV PATH=$PATH:/akpo