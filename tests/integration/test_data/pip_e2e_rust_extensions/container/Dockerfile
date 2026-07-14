FROM registry.access.redhat.com/ubi10/ubi@sha256:fe92bdc2c333e1cdf6c779c10eafcc4a6b0b343de85ff7d1ee26c600390b6d62

# Test disabled network access
RUN if getent hosts www.google.com; then echo "Has network access!"; exit 1; fi

# These packages must be prefetched during the previous phase.
# Refer to the test for further details.
RUN dnf -y install \
    cargo \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-devel \
    libffi-devel \
    openssl-devel \
    perl-interpreter \
    perl-FindBin \
    perl-lib \
    perl-IPC-Cmd \
    perl-File-Compare \
    perl-File-Copy

WORKDIR /src

RUN . /tmp/hermeto.env \
    && python3 -m pip install -r requirements.txt

# See pip/e2e for the resasoning behind switching WORKDIR
RUN cp -r /src /app
WORKDIR /app
