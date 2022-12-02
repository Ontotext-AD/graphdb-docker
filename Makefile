VERSION=10.0.0

build-image:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-amd64 .

build-image-arm64:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-arm64 .

push:
	docker push ontotext/graphdb:${VERSION}

