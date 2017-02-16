VERSION=8.0.3
ee:
	docker build --build-arg edition=ee --build-arg version=${VERSION} -t ontotext/graphdb-ee:${VERSION} .
	docker push ontotext/graphdb-ee:${VERSION}

se:
	docker build --build-arg edition=se --build-arg version=${VERSION} -t ontotext/graphdb-se:${VERSION} .
	docker push ontotext/graphdb-se:${VERSION}


# TODO: Free is special and needs different build file
#free:
#	docker build --build-arg edition=free .
