FROM eclipse-temurin:11-jdk-noble AS builder

ARG version
ARG download_url="https://maven.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${version}/graphdb-${version}-dist.zip"
ARG download_url_checksum="${download_url}.md5"

RUN \
    apt-get update && \
    apt-get install -u unzip && \
    curl -fsSL "${download_url}" > graphdb-${version}-dist.zip && \
    bash -c 'md5sum -c - <<<"$(curl -fsSL ${download_url_checksum})  graphdb-${version}-dist.zip"' && \
    unzip graphdb-${version}-dist.zip && \
    mv graphdb-${version} graphdb

FROM eclipse-temurin:11-jdk-noble

ARG graphdb_parent_dir=/opt/graphdb

ENV GRAPHDB_HOME=${graphdb_parent_dir}/home
ENV GRAPHDB_INSTALL_DIR=${graphdb_parent_dir}/dist
ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH

COPY --from=builder graphdb/ ${GRAPHDB_INSTALL_DIR}/

WORKDIR /tmp

RUN \
    apt-get update && \
    apt-get install -y net-tools less && \
    mkdir -p ${GRAPHDB_HOME} && \
    apt-get clean

ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]

CMD ["-Dgraphdb.home=/opt/graphdb/home", "-Dgraphdb.distribution=docker"]

EXPOSE 7200
EXPOSE 7300
