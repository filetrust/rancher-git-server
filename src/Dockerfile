# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:latest AS builder

ARG CONTAINER_REGISTRY_URL="gwicapcontainerregistry.azurecr.io/"

RUN echo ${CONTAINER_REGISTRY_URL}

RUN apt update && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:rmescandon/yq && \
    apt update && \
    apt install yq -y && \
    apt install -y --no-install-recommends \
    sudo \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    lsb-release \
    gnupg \
    git \
    jq \
    yq -y && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && \
    az --version

WORKDIR /var/lib/git
ADD update-docker-registry.sh /var/lib/git
ADD update-secrets.sh /var/lib/git

RUN git clone --mirror https://github.com/filetrust/icap-infrastructure.git && \
    chmod +x update-docker-registry.sh  && \
    chmod +x update-secrets.sh  && \
    cd icap-infrastructure.git && \
    git config --bool core.bare false && \
    git config receive.denyCurrentBranch ignore && \
    cd /tmp && \
    git clone /var/lib/git/icap-infrastructure.git icap-infra && \
    cd ./icap-infra && \
    git config --global user.email "rancher@glasswall.invalid" && \
    git config --global user.name "Rancher Server" && \
    git checkout add-image-registry && \
    /var/lib/git/update-docker-registry.sh ${CONTAINER_REGISTRY_URL} && \
    git add . && \
    git commit -m 'Update the container registry' && \
    git push --force


RUN --mount=type=secret,id=az-secret cd /tmp/icap-infra && \
    git checkout add-image-registry && \
    /var/lib/git/update-secrets.sh && \
    git add . && \
    git commit -m 'Update the secrets' || true && \
    git push --force

FROM nginx:alpine

RUN set -x && \
  apk --update upgrade                                                          &&  \
  apk add git bash fcgiwrap spawn-fcgi wget sudo su-exec git-daemon yq --repository=http://dl-cdn.alpinelinux.org/alpine/v3.13/community         &&  \
  adduser git -h /var/lib/git -D                                                &&  \
  adduser nginx git                                                             &&  \
  echo "git ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-git-user                &&  \
  git config --system http.receivepack true                                     &&  \
  git config --system http.uploadpack true                                      &&  \
  git config --system user.email "gitserver@git.com"                            &&  \
  git config --system user.name "Rancher Git Server"                            &&  \
  ln -sf /dev/stdout /var/log/nginx/access.log                                  &&  \
  ln -sf /dev/stderr /var/log/nginx/error.log                                   &&  \
  mkdir -p /var/lib/git                                                         &&  \
  chown -R git:git /var/lib/git                                                 &&  \
  chmod -R 775 /var/lib/git

ADD etc /etc
ADD entrypoint.sh /usr/local/bin/entrypoint

WORKDIR /var/lib/git
COPY --from=builder /var/lib/git .

ENTRYPOINT [ "entrypoint" ]
CMD [ "-start" ]


