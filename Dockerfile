# Container image that runs your code
FROM alpine/helm:3.3.1

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

RUN wget https://github.com/instrumenta/kubeval/releases/download/0.15.0/kubeval-windows-amd64.zip \
    && mkdir /kubeval \
    && tar xf kubeval-linux-amd64.tar.gz -C /kubeval \
    && rm -r kubeval-linux-amd64.tar.gz

COPY entrypoint.sh /entrypoint.sh
