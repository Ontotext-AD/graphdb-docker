VERSION=10.2.0

build-image:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-amd64 .

build-image-arm64:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-arm64 arm64-build-on-aws

push:
	docker push ontotext/graphdb:${VERSION}

