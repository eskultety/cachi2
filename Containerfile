FROM docker.io/library/alpine:3.18
LABEL maintainer="Red Hat"

WORKDIR /src
RUN apk update &&\
    apk upgrade &&\
    apk add \
    go \
    git \
    npm \
    python3 \
    py3-pip

COPY . .

RUN pip3 install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    pip3 install --no-cache-dir . && \
    # the git folder is only needed to determine the package version
    rm -rf .git

WORKDIR /src/js-deps
RUN npm install && \
    ln -s "${PWD}/node_modules/.bin/corepack" /usr/local/bin/corepack && \
    corepack enable yarn && \
    apk del npm

ENTRYPOINT ["cachi2"]
