VERSION =
ARCH =
TAG = ontotext/graphdb:${VERSION}

check-env:
ifndef VERSION
	$(error VERSION is undefined)
endif
ifdef ARCH
TAG := ${TAG}-${ARCH}
endif

build: check-env
	docker image build --pull --no-cache --build-arg version=${VERSION} --tag ${TAG} .

push: check-env
	docker image push ${TAG}
