VERSION =
ARCH =
TAG = ontotext/graphdb:${VERSION}
DOCKERFILE_BASE = "https://raw.githubusercontent.com/adoptium/containers/057e5aa7581e96b8a2334290e750b329d62abfdf/11/jdk/ubuntu/jammy/Dockerfile"

check-env:
ifndef VERSION
	$(error VERSION is undefined)
endif
ifdef ARCH
TAG := ${TAG}-${ARCH}
endif

temurin:
	curl ${DOCKERFILE_BASE} > Dockerfile.base
	# remove copy of entrypoint since we don't have it locally and we don't need it
	sed -i '/^COPY/d;/^ENTRYPOINT/d' Dockerfile.base
	# change the base image to noble
	sed -i 's/FROM ubuntu:22.04/FROM ubuntu:24.04/' Dockerfile.base
	docker image build --pull --file Dockerfile.base --tag eclipse-temurin:11-jdk-noble .

build: check-env temurin
	docker image build --build-arg version=${VERSION} -t ${TAG} .

push: check-env
	docker push ${TAG}
