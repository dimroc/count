REPO=dimroc/counting_company

.DEFAULT_GOAL := build
.PHONY: build push


build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)
