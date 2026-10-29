FROM eclipse-temurin:25-jdk-noble AS builder

ARG version
ARG download_url="https://maven.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${version}/graphdb-${version}-dist.zip"
ARG download_url_checksum="${download_url}.sha1"

RUN \
    apt-get update && \
    apt-get install -u unzip && \
    curl -fsSL "${download_url}" > graphdb-${version}-dist.zip && \
    bash -c 'sha1sum -c - <<<"$(curl -fsSL ${download_url_checksum})  graphdb-${version}-dist.zip"' && \
    unzip graphdb-${version}-dist.zip && \
    mv graphdb-${version} graphdb

FROM eclipse-temurin:25-jdk-noble

ENV USE_SYSTEM_CA_CERTS="no"

ENV graphdb__home__data="/var/lib/graphdb/data"
ENV graphdb__home__logs="/var/lib/graphdb/logs"
ENV graphdb__home__work="/var/lib/graphdb/work"
ENV graphdb__workbench__importDirectory="/var/lib/graphdb/imports"
ENV graphdb__workbench__serverinfo="false"
ENV graphdb__distribution="docker"

COPY --from=builder /graphdb /opt/graphdb

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    net-tools \
    less \
    curl && \
  useradd --uid 10001 --user-group --no-create-home --shell /usr/sbin/nologin graphdb && \
  mkdir -p /var/lib/graphdb && \
  chown graphdb:graphdb /var/lib/graphdb

WORKDIR /opt/graphdb

USER graphdb

CMD ["/opt/graphdb/bin/graphdb"]

EXPOSE 7200
EXPOSE 7300
