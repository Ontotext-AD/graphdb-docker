VERSION=8.0.4

free:
	docker build --build-arg edition=free --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-free free-edition

ee:
	docker build --build-arg edition=ee --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-ee .

se:
	docker build --build-arg edition=se --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-se .

ee-upload: ee
	docker push ontotext/graphdb:${VERSION}-ee

se-upload: se
	docker push ontotext/graphdb:${VERSION}-se

# TODO: Free is special and needs different build file
#free:
#	docker build --build-arg edition=free .
#
#
