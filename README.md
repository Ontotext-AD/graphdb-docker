# Building

[Ontotext](https://www.ontotext.com/) provides prebuild images with every release of GraphDB. These images are available
at [Docker Hub](https://hub.docker.com/r/ontotext/graphdb/).

If you want to make changes to the image you can build it from this repository.
To build the image you can use the provided [Makefile](./Makefile) or simply invoke the `docker image build` command
directly. Note that there is a `version` build argument that must be provided. When using `make` this parameter will
automatically be picked up from the `VERSION` variable.

For example, if you want to build version `10.7.0`, you can run the following command:
```shell
make build VERSION="10.7.0"
```

# Running

After successfully building the image you should have it locally as `ontotext/graphdb:<VERSION>`. If you have specified 
`10.7.0` for the `VERSION` variable, the image will be `ontotext/graphdb:10.7.0`.

## Exposing the ports

By default, GraphDB listens on two ports - `7200` and `7300`. To map these ports to the host use the `--publish`
(or the shorthand `-p`) docker flag.

```shell
docker container run -it -p 7200:7200 -p 7300:7300 ontotext/graphdb:10.7.0
```

## Persisting data

Containers do not persist data on the host machine, by default. To persist the container data we could map directories
on the host to directories inside the container, or use volumes.

The GraphDB image is configured to store its data to `/opt/graphdb/home`. Also, the default 
[server import](https://graphdb.ontotext.com/documentation/10.6/loading-data-using-the-workbench.html#importing-server-files) directory
is `$HOME/graphdb-import`, but this could be changed using the `graphdb.workbench.importDirectory` configuration 
property.

To map directories from the host use:
```shell
docker container run -it -p 7200:7200 \
  -v /host/path/for/graphdb/data:/opt/graphdb/home \
  -v /host/path/for/graphdb/imports:/root/graphdb-import \
  ontotext/graphdb:10.7.0
```

To do the same but using volumes, we need to first create the volumes.
```shell
docker volume create graphdb-data
docker volume create graphdb-import

docker container run -it -p 7200:7200 \
  -v graphdb-data:/opt/graphdb/home \
  -v graphdb-import:/root/graphdb-import \
  ontotext/graphdb:10.7.0
```

## Configuring

GraphDB configurations can be provided using the `graphdb.properties` file, using the `GDB_JAVA_OPTS` environment
variable, or directly command line arguments.

To provide a `graphdb.properties` file you can mount a file on the host to the configuration directory inside the 
container.

```shell
docker container run -it -p 7200:7200 \
  -v /host/path/to/graphdb.properties:/opt/graphdb/home/conf/graphdb.properties \
  ontotext/graphdb:10.7.0
```

The `GDB_JAVA_OPTS` environment variable could also be used to configure GraphDB. Its value must be a list of space 
separated key=value pairs prefixed by `-D`, following the java system properties syntax.

```shell
docker container run -it -p 7200:7200 \
  -e GDB_JAVA_OPTS="-Dgraphdb.workbench.importDirectory=/var/graphdb/import" \
  ontotext/graphdb:10.7.0
```

Using command line arguments follows the same syntax as the `GDB_JAVA_OPTS` - java system properties. To use this 
approach, just append the arguments after the image name

```shell
docker container run -it -p 7200:7200 \
  ontotext/graphdb:10.7.0 -Dgraphdb.workbench.importDirectory=/var/graphdb/import -Dgraphdb.home=/opt/graphdb/home
```

NOTE: If you use this approach, make sure to include `-Dgraphdb.home`. If you don't - GraphDB data will be saved to 
`/opt/graphdb/dist/data`.

## Setting a license file

There are [several ways](https://graphdb.ontotext.com/documentation/10.6/set-up-your-license.html) to set a license 
for GraphDB.

When running inside a container, the best way is using a 
[file](https://graphdb.ontotext.com/documentation/10.6/set-up-your-license.html#setting-up-licenses-through-a-file).

Either mount the file as `graphdb.license` under the `conf/` directory
```shell
docker container run -it -p 7200:7200 \
  -v /path/to/my-graphdb.license:/opt/graphdb/home/conf/graphdb.license \
  ontotext/graphdb:10.7.0
```
or mount it to an arbitrary path and the GraphDB where it is
```shell
docker container run -it -p 7200:7200 \
  -v /path/to/my-graphdb.license:/etc/graphdb/graphdb.license \
  -e GDB_JAVA_OPTS="-Dgraphdb.license.file=/etc/graphdb/graphdb.license" \
  ontotext/graphdb:10.7.0
```

# Using the `importrdf` tool

The [importrdf](https://graphdb.ontotext.com/documentation/10.6/cli-importrdf.html) command line tool can be used to 
load big amounts of data. 

Note that GraphDB should be stopped before using the tool. The tool also requires a valid license.

To run the tool we need to override the image entrypoint, because by default, it starts GraphDB. We also need to map
any files needed for the import.

```shell
docker container run -it -p 7200:7200 \
  -v /path/to/my-graphdb.license:/opt/graphdb/home/conf/graphdb.license \
  -v $PWD/preload:/graphdb-data-import \
  --entrypoint /opt/graphdb/dist/bin/importrdf \
  ontotext/graphdb:10.7.0 \
  preload -Dgraphdb.home=/opt/graphdb/home -f -c /graphdb-data-import/repo-config.ttl /graphdb-data-import/data.nt 
```

Note that this example uses files from this repository, so make sure you run the command from the repository root 
directory. Also, as mentioned above, we need to provide the `graphdb.home` configuration property, since we are
overriding the default arguments used by GraphDB.

What this command does is:
1. Mount the GraphDB license to `/opt/graphdb/home/conf/graphdb.license`
2. Mount the `preload` directory from this repository to `/graphdb-data-import`
3. Override the image entrypoint to the `importrdf` tool
4. Configure the GraphDB home directory
5. Finally, run `importrdf preload` command, which will
   1. Create a repository using the `repo-config.ttl` file
   2. Import the `test.nt` file in that repository
