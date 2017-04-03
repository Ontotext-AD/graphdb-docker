This keeps the infrastructure that builds docker images for [GraphDB](http://graphdb.ontotext.com/)

Check [Docker Hub Images](https://hub.docker.com/r/ontotext/graphdb/) for information on how to use the images.

Note that to use the docker images, you must get a license from us first.

Currently there are no public images for GraphDB Free and you will have to
build those if needed from the zip distribution that you get after registering
on our website.

# Building a docker image based on the free edition

You will need docker and make installed on your machine.

1. Checkout this repository
1. Register on the Ontotext website for the GraphDB Free edition. Download the zip file and place it in the *free-edition* subdirectory
1. Run
```
make free VERSION=<the-version-that-you-got>
```

for example the most recent version as of this writing is 8.0.6 so run
```
make free VERSION=8.0.6
```

this will build an image that you can use called ontotext/graphdb:8.0.6-free.
You can run the image now with
```
docker run -d -p 7200:7200 graphdb-free
```

Consult the docker hub documentation for more information.


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

```
make ee VERSION=<version-of-graphdb-you-want>
```
for the enterprise edition and

```
make se VERSION=<version-of-graphdb-you-want>
```

for the standard edition
