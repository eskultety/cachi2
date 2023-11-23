FROM fedora-toolbox:39 as fedora-toolbox
FROM docker.io/library/golang:1.20.0-bullseye as golang_120
FROM docker.io/library/golang:1.22.0-bullseye as golang_122
FROM docker.io/library/node:22.3.0-bullseye as node_223

########################
# PREPARE OUR BASE IMAGE
########################
FROM fedora-toolbox as base
RUN dnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    createrepo_c \
    git-core \
    python3 \
    && dnf clean all

######################
# BUILD/INSTALL CACHI2
######################
FROM base as builder
WORKDIR /src
COPY . .
RUN dnf -y install \
    --setopt install_weak_deps=0 \
    --nodocs \
    gcc \
    python3-devel \
    python3-pip \
    python3-setuptools \
    && dnf clean all

RUN python3 -m venv /venv && \
    /venv/bin/pip install -r requirements.txt --no-deps --no-cache-dir --require-hashes && \
    /venv/bin/pip install --no-cache-dir .

##########################
# ASSEMBLE THE FINAL IMAGE
##########################
FROM base
LABEL maintainer="Red Hat"
LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true"

# copy Go SDKs and Node.js installation from official images
COPY --from=golang_120 /usr/local/go /usr/local/go/go1.20
COPY --from=golang_122 /usr/local/go /usr/local/go/go1.22
COPY --from=node_223 /usr/local/lib/node_modules/corepack /usr/local/lib/corepack
COPY --from=node_223 /usr/local/bin/node /usr/local/bin/node
COPY --from=builder /venv /venv

# link corepack, yarn, and go to standard PATH location
RUN ln -s /usr/local/lib/corepack/dist/corepack.js /usr/local/bin/corepack && \
    ln -s /usr/local/lib/corepack/dist/yarn.js /usr/local/bin/yarn && \
    ln -s /usr/local/go/go1.22/bin/go /usr/local/bin/go && \
    ln -s /venv/bin/cachi2 /usr/local/bin/cachi2

CMD ["/usr/local/bin/cachi2"]
