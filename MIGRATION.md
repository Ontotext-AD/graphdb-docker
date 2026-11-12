# Migrating to the GraphDB 12 

> [!IMPORTANT]
> This procedure covers **only** the migration steps for the GraphDB container. For migration of GraphDB data,
> configurations, connectors, clusters, etc., check the 
> [release notes](https://graphdb.ontotext.com/documentation/12.0/release-notes.html) and
> [migration guide](https://graphdb.ontotext.com/documentation/12.0/migrating-graphdb-configurations.html).

Before version 12.0, the GraphDB installation directory was `/opt/graphdb/dist` and all data and logs were under
`/opt/graphdb/home`. Additionally, the server files import directory was `/root/graphdb-import` since the container ran
with the `root` user.

Starting with GraphDB 12.0, the container runs with a dedicated `graphdb` user with UID and GID of `10001. Additionally,
changes to the directory structure was introduced, notably, data and logs are now under a separate root directory.
This is described in the table bellow:

| Directory | Before | Now |
|---        |---     |---   |
| Installation           | /opt/graphdb/dist       | /usr/share/graphdb     |
| Configuration           | /opt/graphdb/home/conf       | /usr/share/graphdb/conf     |
| Data          | /opt/graphdb/home/data       | /var/lib/graphdb/data     |
| Work           | /opt/graphdb/home/work       | /var/lib/graphdb/work     |
| Server files import           | /root/graphdb-home       | /var/lib/graphdb/imports     |
| Logs           | /opt/graphdb/home/logs       | /var/log/graphdb     |

## Migrating data directories

To migrate the data directories, execute the following steps:

These steps assume that the data volume used for graphdb is called `graphdb-data`.

1. Stop the old GraphDB container
2. Run a temporary container to change the owner of the files and directories
    ```shell
    docker run -v graphdb-data:/data --user root ontotext/graphdb:12.0.0 chown -R graphdb:graphdb /data  
    ```
3. Optionally, delete the logs subdirectory
    ```shell
    docker run -v graphdb-data:/data ontotext/graphdb:12.0.0 rm -rf /data/logs
    ```
4. If using server import files, change the permissions for the files and directories on the host to allow reading
    ```
    chmod -R a+r /path/to/graphdb-imports
    ```
   
If using bind mounts, make sure the permissions on the host directories and files allow the `graphdb` user to read and 
write to them.

## Migrating configurations

If mounting any files under the `conf/` directory make sure you use the new location: `/usr/share/graphdb/conf`.