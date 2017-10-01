REPO=dimroc/counting_company_ml
REMOTE=us.gcr.io/counting-company-production/ml

.DEFAULT_GOAL := build
.PHONY: build push


build:
	docker build -t $(REPO) .

push:
	docker tag $(REPO) $(REMOTE)
	gcloud docker -- push $(REMOTE)
