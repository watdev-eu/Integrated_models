# Start from a minimal Debian base image
# FROM debian:stable-slim
FROM ubuntu:18.04

LABEL org.opencontainers.image.source="https://github.com/nfmsu/Integrated_models"
ENV DEBIAN_FRONTEND=noninteractive
ENV MODDIR=/modeller3/WATDEV/TOOLBOX

ARG SWAT_VERSION="v1.1.3"
ARG DSSAT_VERSION="v4.8.0.15"

# === Install dependencies ===
RUN set -eux; \
    apt-get update && apt-get install -y libgfortran4 git wget unzip rsync ca-certificates build-essential gfortran cmake vim; \
    rm -rf /var/lib/apt/lists/*

#    apt-get update && apt-get install -y --no-install-recommends \
#        build-essential gfortran cmake git pkg-config wget unzip rsync ca-certificates \

# === Clone required internal and external repositories (to keep the sym links operational) ===
RUN set -eux; \
    git clone https://github.com/watdev-eu/Integrated_models ${MODDIR}; \
    git clone --depth 1 --branch ${DSSAT_VERSION} https://github.com/DSSAT/dssat-csm-os.git ${MODDIR}/SourceCode_dssat-csm-os-master_v4.8; \
    git clone --depth 1 --branch ${SWAT_VERSION} https://github.com/spark-hydro/SWAT-MODFLOW3 /tmp/swat; \
    mv /tmp/swat/src "${MODDIR}/SourceCodeSM_V3"; \
    rm -Rf /tmp/swat;   

WORKDIR ${MODDIR}

# RUN make swat -- this does not work yet, so running manual

CMD ["/bin/bash"]
