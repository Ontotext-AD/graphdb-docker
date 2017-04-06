FROM openjdk:8-jdk

# Build time arguments
ARG version=8.0.3
ARG edition=free

ENV GRAPHDB_PARENT_DIR=/opt/graphdb
ENV GRAPHDB_HOME=${GRAPHDB_PARENT_DIR}/home

ENV GRAPHDB_INSTALL_DIR=${GRAPHDB_PARENT_DIR}/dist

ADD graphdb-free-${version}-dist.zip /tmp

RUN mkdir -p ${GRAPHDB_PARENT_DIR} && \
    cd ${GRAPHDB_PARENT_DIR} && \
    unzip /tmp/graphdb-free-${version}-dist.zip && \
    rm /tmp/graphdb-free-${version}-dist.zip && \
    mv graphdb-${edition}-${version} dist && \
    mkdir -p ${GRAPHDB_HOME}

ENV PATH=${GRAPHDB_INSTALL_DIR}/bin:$PATH

CMD ["-Dgraphdb.home=/opt/graphdb/home"]

ENTRYPOINT ["/opt/graphdb/dist/bin/graphdb"]

EXPOSE 7200
