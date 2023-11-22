FROM registry.access.redhat.com/ubi9/ubi-minimal
LABEL maintainer="Red Hat"

WORKDIR /src
RUN microdnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    golang-bin \
    git-core \
    npm \
    python3 \
    python3-pip \
    && microdnf clean all

COPY . .

RUN pip3 install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    pip3 install --no-cache-dir . && \
    # the git folder is only needed to determine the package version
    rm -rf .git

WORKDIR /src/js-deps
RUN npm install && \
    ln -s "${PWD}/node_modules/.bin/corepack" /usr/local/bin/corepack && \
    corepack enable yarn && \
    microdnf -y remove npm

ENTRYPOINT ["cachi2"]
