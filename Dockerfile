FROM eclipse-temurin:25-jdk-noble AS builder

ARG version
ARG download_url="https://docker-registry.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${version}/graphdb-${version}-dist.zip"
ARG download_url_checksum="${download_url}.sha1"
ARG disable_checksum_check

ADD ${download_url} /graphdb-${version}-dist.zip

RUN apt-get update && \
    apt-get install -y unzip curl && \
    if [ -z "${disable_checksum_check}" ]; then \
      printf '%s  %s\n' "$(curl -fsSL "${download_url_checksum}")" "graphdb-${version}-dist.zip" | sha1sum -c -; \
    fi && \
    unzip graphdb-${version}-dist.zip && \
    mv /graphdb-${version} /graphdb

FROM eclipse-temurin:25-jdk-noble

ENV graphdb__workbench__importDirectory="/var/lib/graphdb/imports" \
    graphdb__home__data="/var/lib/graphdb/data" \
    graphdb__home__work="/var/lib/graphdb/work" \
    graphdb__home__logs="/var/log/graphdb"

ENV graphdb__workbench__serverinfo="false" \
    graphdb__distribution="docker"

COPY --from=builder /graphdb /usr/share/graphdb

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      net-tools \
      less \
      curl && \
    useradd --uid 10001 --user-group --no-create-home --shell /usr/sbin/nologin graphdb && \
    mkdir -p /var/lib/graphdb /var/log/graphdb && \
    chown graphdb:graphdb /var/lib/graphdb /var/log/graphdb

WORKDIR "/usr/share/graphdb"

USER graphdb

CMD ["/usr/share/graphdb/bin/graphdb"]

EXPOSE 7200 7300
