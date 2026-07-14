FROM registry.access.redhat.com/ubi9/ubi@sha256:d99e89bd03ec3204d8c70af2fe643263fe0ecc5f0f7695f36cb14d96fd6b9046

# Test disabled network access
RUN if getent hosts www.google.com; then echo "Has network access!"; exit 1; fi

# Install dependencies from RPM lockfile
RUN dnf -y install golang npm

WORKDIR /src/gomod-package
RUN . /tmp/hermeto.env && go build

WORKDIR /src/npm-package
RUN . /tmp/hermeto.env && npm install
