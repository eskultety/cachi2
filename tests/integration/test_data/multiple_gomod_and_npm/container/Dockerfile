FROM registry.access.redhat.com/ubi9/ubi@sha256:8bf0e8f20737e9c8a68c8a498299e9504ab397b1b1f2837acb2fef12ec698f0e

# Test disabled network access
RUN if getent hosts www.google.com; then echo "Has network access!"; exit 1; fi

# Install dependencies from RPM lockfile
RUN dnf -y install golang npm

WORKDIR /src/gomod-package
RUN . /tmp/hermeto.env && go build

WORKDIR /src/npm-package
RUN . /tmp/hermeto.env && npm install
