.PHONY: cloudsqlproxy railsml secretfiles secrets ssh console info rollout rollback jobs

ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[\
	{"name":"rails","image":"RAILSIMAGE"},\
	{"name":"ml","image":"MLIMAGE"}\
	]}}}}'

cloudsqlproxy:
	kubectl apply -f sqlproxy-deployment.yaml
	kubectl apply -f sqlproxy-service.yaml

railsml:
	kubectl apply -f ./railsml-deployment.yaml
	kubectl apply -f ./railsml-service.yaml
	kubectl apply -f ./ingress.yaml

secretfiles:
	kubectl create secret generic cloudstorage-instance-credentials --from-file=credentials.json=../secrets/gcloudstorage.production.json
	kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=../secrets/gcloudsql.json

secrets:
	kubectl create secret generic rails-environment --from-env-file=./rails.env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic ml-environment --from-env-file=./ml.env --dry-run=true -o yaml | kubectl apply -f -

ssh:
	kubectl exec -it $(POD) -c rails -- /bin/bash

console:
	kubectl exec -it $(POD) -c rails -- bundle exec rails console

info:
	kubectl cluster-info
	kubectl get ingress,services,deployments,rs,pods,jobs -o wide

rollout:
	kubectl patch deployment railsml-deployment -p \
		$(subst RAILSIMAGE,$(shell ./docker-repodigest rails),$(subst MLIMAGE,$(shell ./docker-repodigest ml),$(ROLLOUT_PATCH)))

rollback:
	kubectl rollout undo deployment/railsml-deployment

jobs:
	kubectl create -f ./jobs/rake.yaml
