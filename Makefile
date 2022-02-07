VERSION=10.0.0-M1

build-image:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION} .

ee-upload: ee
	docker push ontotext/graphdb:${VERSION}

se-upload: se
	docker push ontotext/graphdb:${VERSION}
