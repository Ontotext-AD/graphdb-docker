VERSION =
ARCH =
TAG = docker-registry.ontotext.com/graphdb:${VERSION}

check-env:
ifndef VERSION
	$(error VERSION is undefined)
endif
ifdef ARCH
TAG := ${TAG}-${ARCH}
endif

build: check-env
	docker image build --build-arg version=${VERSION} -t ${TAG} .

push: check-env
	docker image push ${TAG}
