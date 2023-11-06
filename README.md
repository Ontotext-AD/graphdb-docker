This keeps the infrastructure that builds docker images for [GraphDB](http://graphdb.ontotext.com/)

Check [Docker Hub Images](https://hub.docker.com/r/ontotext/graphdb/) for information on how to use the images.

# Building a docker image

You will need docker and make installed on your machine.

1. Checkout this repository
1. Run
```bash
make build-image VERSION=<the-version-that-you-want>
```

for example the most recent version as of this writing is 10.2.2 so run
```bash
make build-image VERSION=10.2.2
```

this will build an image that you can use called ontotext/graphdb:10.2.2
You can run the image now with

```bash
docker run -d -p 7200:7200 ontotext/graphdb:10.2.2
```

Consult the docker hub documentation for more information.

### Preload a repository

Go to the `preload` folder to run the bulk load data when GraphDB is stopped.

```bash
cd preload
```

By default it will:

* Create or override a repository defined in the `graphdb-repo-config.ttl` file (can be changed manually in the file, default is `demo`)
* Upload a test ntriple file from the `preload/import` subfolder.

> See the [GraphDB preload documentation](https://graphdb.ontotext.com/documentation/10.2/loading-data-using-importrdf.html) for more details.

When running the preload docker-compose various parameters can be provided in the `preload/.env` file:

```bash
GRAPHDB_VERSION=10.2.2
GRAPHDB_HEAP_SIZE=3g
GRAPHDB_HOME=../graphdb-data
REPOSITORY_CONFIG_FILE=./graphdb-repo.ttl
```

Build and run:

```bash
docker-compose build
docker-compose up -d
```

> GraphDB data will go to `/data/graphdb`

Go back to the root of the git repository to start GraphDB:

```bash
cd ..
```

### Start GraphDB

To start GraphDB run the following **from the root of the git repository**:

```bash
docker-compose up -d --build
```

> It will use the repo created by the preload in `graphdb-data/`

> Feel free to add a `.env` file similar to the preload repository to define variables.

## Cluster mode

If you want to run GraphDB in cluster mode, there are a few additional things to consider.

- Port `7300` (the default RPC port) should be exposed
- A cluster secret must be provided for all cluster nodes with the property `graphdb.auth.token.secret`

An example command for a GraphDB node ready for cluster mode:

```bash
docker run -d -p 7200:7200 -p 7300:7300 ontotext/graphdb:10.2.2 /opt/graphdb/dist/bin/graphdb -Dgraphdb.auth.token.secret=superSecretToken
```

If you wish to use an `external proxy` with the cluster, you can launch it using Docker with the following command:

```bash
docker run -d -p 7200:7200 -p 7300:7300 --entrypoint /opt/graphdb/dist/bin/cluster-proxy ontotext/graphdb:10.2.2 -Dgraphdb.auth.token.secret=superSecretToken -g http://<hostname>:7200
```

Notice that:

- The entrypoint has been overridden to execute the `cluster-proxy` script in `/opt/graphdb/dish/bin` which is used to start the external proxy mode
- The `-g` parameter tells the external proxy where it can find a GraphDB instance that is part of a cluster. One instance address is enough, the other cluster nodes will be discovered automatically.
- The external proxy still needs a `graphdb.auth.token.secret` in order to communicate with the cluster

The logs of the running container will inform you that GraphDB has been started in proxy mode and if it can communicate with the cluster nodes successfully

> See the [GraphDB external proxy documentation](https://graphdb.ontotext.com/documentation/10.4/creating-a-cluster.html?start-the-external-proxy#configure-external-cluster-proxy) for more details.

# Issues

You can report issues in the GitHub issue tracker or at graphdb-support at ontotext.com

# Contributing

You are invited to contribute new features, fixes, or updates, large or small;
we are always thrilled to receive pull requests, and do our best to process
them as fast as we can.

Before you start to code, we recommend discussing your plans through a GitHub
issue, especially for more ambitious contributions. This gives other
contributors a chance to point you in the right direction, give you feedback on
your design, and help you find out if someone else is working on the same
thing.
