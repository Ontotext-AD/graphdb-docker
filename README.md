# GraphDB container image

> [!IMPORTANT]
> **GraphDB 12 and its container image introduce breaking changes.** The runtime, filesystem layout, default user, and container startup behavior differ from images for GraphDB 9–11. **Read the [migration guide](MIGRATION.md) before upgrading**, particularly if you use bind mounts, custom startup commands, or scripts that depend on the old paths.

This repository builds a container image for GraphDB 12 and higher from the GraphDB distribution archive.

## Build

Supply the GraphDB distribution version as a build argument:

```bash
docker build --build-arg version=12.0.0 --tag ontotext/graphdb:12.0.0 .
```

Replace `12.0.0` with the exact available GraphDB version.

## Run

For a quick, disposable instance:

```bash
docker run --rm --name graphdb \
  -v /path/to/graphdb.license:/usr/share/graphdb/conf/graphdb.license \
  -p 7200:7200 \
  ontotext/graphdb:12.0.0
```

> [!NOTE]
> You need to provide a valid GraphDB license in order to use it.

Open GraphDB Workbench at [http://localhost:7200](http://localhost:7200).

For persistent data and logs, use named volumes.

```bash
docker run -d --name graphdb \
  -p 7200:7200 \
  -v /path/to/graphdb.license:/usr/share/graphdb/conf/graphdb.license \
  -v graphdb-data:/var/lib/graphdb \
  -v graphdb-logs:/var/log/graphdb \
  ontotext/graphdb:12.0.0
```

## Filesystem layout

| Path | Description |
| --- | --- |
| `/usr/share/graphdb` | Installation directory |
| `/usr/share/graphdb/conf` | Configuration files (graphdb.properties, logback.xml, etc.)|
| `/var/lib/graphdb/data` | Persistent data (repositories, users, etc.) |
| `/var/lib/graphdb/work` | Working files (file uploads, temporary files)|
| `/var/lib/graphdb/imports` | Files for server imports |
| `/var/log/graphdb` | Log files|

> [!IMPORTANT]
> The image runs with the `graphdb` (UID **10001**, with a matching primary group created during the build) user, 
> not root. 
> Mounted directories must be writable by this user. Docker-managed named volumes are generally the easiest option.
> For bind mounts, set ownership and permissions on the host before starting the container.

If mounting `/var/lib/graphdb/imports` separately, ensure that mount is readable.

## Configuration

The recommended way of configuring the GraphDB container is through [environment variables](https://graphdb.ontotext.com/documentation/11.5/directories-and-config-properties.html#configuring-graphdb-through-environment-variables).
Alternatively, the `graphdb.properties`, `logback.xml`, or any other configuration files, can be mounted directly inside
the configuration directory.

```bash
docker run --rm -p 7200:7200 \
  -e graphdb__workbench__serverinfo=true \
  -v /path/to/graphdb.properties:/usr/share/graphdb/conf/graphdb.properties:ro \
  -v graphdb-data:/var/lib/graphdb \
  ontotext/graphdb:12.0.0
```

## Startup and command overrides

Unlike the previous images, starting GraphDB 12 there is **no Docker `ENTRYPOINT`** override. It uses:

```dockerfile
CMD ["/usr/share/graphdb/bin/graphdb"]
```

Consequently, arguments placed after the image name **replace the command** 
rather than being appended to the GraphDB launcher. To pass launcher arguments, include the executable explicitly:

```bash
docker run --rm -p 7200:7200 ontotext/graphdb:12.0.0 \
  /usr/share/graphdb/bin/graphdb -Dregister-plugins=com.ontotext.trree.plugin.js.JSPlugin
```

## Importing trusted CA certificates

Custom CA certificates can be imported into the JVM truststore automatically at container startup.

To enable this functionality:
1. Set `USE_SYSTEM_CA_CERTS=1`
2. Mount your certificates into `/certificates` inside the container
3. Ensure certificates are in PEM format (.crt files)

This creates trust store, where all system-wide certificates are imported, including the ones provided under
`/certificates`. Java is then configured to use that trust store by default.
