FROM eclipse-temurin:11-jdk

# Build time arguments
ARG version=10.0.0

ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home

ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist

WORKDIR /tmp

RUN apt update && \
    apt install -y bash curl util-linux wget zip  && \
    curl -fsSL "https://maven.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${version}/graphdb-${version}-dist.zip" > \
    graphdb-${version}.zip && \
    bash -c 'md5sum -c - <<<"$(curl -fsSL https://maven.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${version}/graphdb-${version}-dist.zip.md5)  graphdb-${version}.zip"' && \
    mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-${version}.zip && \
    rm /tmp/graphdb-${version}.zip && \
    mv graphdb-${version} dist && \
    mkdir -p ${GRAPHDB_HOME} && \
    apt clean

ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH

CMD ["-Dgraphdb.home=/opt/graphdb/home"]

ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]

EXPOSE 7200
EXPOSE 7300
