VERSION=10.0.0

build-image:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION} .

push:
	docker push ontotext/graphdb:${VERSION}

