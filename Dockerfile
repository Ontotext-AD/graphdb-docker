FROM openjdk:8-jdk

# Build time arguments
ARG version=8.0.3
ARG edition=ee

ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home

ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist

WORKDIR /tmp

RUN curl -fsSL "http://maven.ontotext.com/content/groups/all-onto/com/ontotext/graphdb/graphdb-${edition}/${version}/graphdb-${edition}-${version}-dist.zip" > \
    graphdb-${edition}-${version}.zip && \
    bash -c 'md5sum -c - <<<"$(curl -fsSL http://maven.ontotext.com/content/groups/all-onto/com/ontotext/graphdb/graphdb-${edition}/${version}/graphdb-${edition}-${version}-dist.zip.md5) graphdb-${edition}-${version}.zip"' && \
    mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-${edition}-${version}.zip && \
    rm /tmp/graphdb-${edition}-${version}.zip && \
    mv graphdb-${edition}-${version} dist && \
    mkdir -p ${GRAPHDB_HOME}

ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH

CMD ["-Dgraphdb.home=/opt/graphdb/home"]

ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]

EXPOSE 7200
