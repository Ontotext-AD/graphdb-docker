This keeps the infrastructure that builds docker images for [GraphDB](http://graphdb.ontotext.com/)

Check [Docker Hub Images](https://hub.docker.com/r/ontotext/graphdb/) for information on how to use the images.

Note that to use GraphDB EE or SE docker images, you must get a license from us first.

Currently there are no public images for GraphDB Free and you will have to build those if needed from the zip distribution that you get after registering on our website.

# Building a docker image based on the free edition

You will need docker and make installed on your machine.

1. Checkout this repository
1. Register on the Ontotext website for the GraphDB Free edition. Download the zip file and place it in the *free-edition* subdirectory
1. Run
```bash
make free VERSION=<the-version-that-you-got>
```

for example the most recent version as of this writing is 9.7.0 so run
```bash
make free VERSION=9.7.0
```

this will build an image that you can use called ontotext/graphdb:9.7.0-free.
You can run the image now with

```bash
docker run -d -p 7200:7200 ontotext/graphdb:9.7.0-free
```

Consult the docker hub documentation for more information.

# Preload and start GraphDB with docker-compose

The `docker-compose.yml` files to deploy GraphDB use the `free-edition` build by default. It requires to have downloaded and placed the GraphDB distribution `.zip` file in the `free-edition/` folder. 

You can directly use [GraphDB Standard and Enterprise edition DockerHub images](https://hub.docker.com/r/ontotext/graphdb/) by editing the `docker-compose.yaml` files:

* Use `image: ontotext/graphdb:9.3.0-se` for the **Standard Edition**
* Use `image: ontotext/graphdb:9.3.0-ee` for the **Enterprise Edition**
* Comment or remove the `build` object (used for the **Free Edition**).

### Preload a repository

Go to the `preload` folder to run the bulk load data when GraphDB is stopped.

```bash
cd preload
```

By default it will:

* Create or override a repository defined in the `graphdb-repo-config.ttl` file (can be changed manually in the file, default is `demo`)
* Upload a test ntriple file from the `preload/import` subfolder.

> See the [GraphDB preload documentation](http://graphdb.ontotext.com/documentation/free/loading-data-using-preload.html) for more details.

When running the preload docker-compose various parameters can be provided in the `preload/.env` file:

```bash
GRAPHDB_VERSION=9.3.0
GRAPHDB_HEAP_SIZE=2g
GRAPHDB_HOME=../graphdb-data
REPOSITORY_CONFIG_FILE=./graphdb-repo-config.ttl
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
docker-compose up -d
```

> It will use the repo created by the preload in `graphdb-data/`

> Feel free to add a `.env` file similar to the preload repository to define variables.


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

# Making changes to the images and building your own version

The following command should be able to build you a custom image that takes your local changes into account

```bash
make ee VERSION=<version-of-graphdb-you-want>
```
for the enterprise edition and

```bash
make se VERSION=<version-of-graphdb-you-want>
```

for the standard edition.
