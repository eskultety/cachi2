# hadolint global ignore=DL3007
FROM docker.io/rockylinux/rockylinux:9.3@sha256:0e03560c97b83bf0a478866cc086a0185730123009267de9cd33d09f1e51c5da
LABEL maintainer="Red Hat"

WORKDIR /src
RUN dnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    gcc \
    git-core \
    golang-bin \
    nodejs \
    npm \
    python3 \
    python3-devel \
    python3-pip \
    python3-setuptools \
    && dnf clean all

COPY . .

RUN pip3 install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    pip3 install --no-cache-dir . && \
    # the git folder is only needed to determine the package version
    rm -rf .git

WORKDIR /src/js-deps
RUN npm install && \
    ln -s "${PWD}/node_modules/.bin/corepack" /usr/local/bin/corepack && \
    corepack enable yarn && \
    dnf -y remove npm

ENTRYPOINT ["cachi2"]
