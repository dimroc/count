REPO=dimroc/counting_company

.DEFAULT_GOAL := build
.PHONY: build push ecr-push


build:
	docker build -t $(REPO) .

push:
	docker push $(REPO)

ecr-push:
	./bin/ecr-login
	docker tag dimroc/counting_company:latest 654158331692.dkr.ecr.us-east-1.amazonaws.com/countingcompany:latest
	docker push 654158331692.dkr.ecr.us-east-1.amazonaws.com/countingcompany:latest
