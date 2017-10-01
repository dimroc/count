.PHONY: secrets deployment ssh info console

ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[\
	{"name":"rails","image":"us.gcr.io/counting-company-production/rails:latest"},\
	{"name":"ml","image":"us.gcr.io/counting-company-production/ml:latest"}\
	]}}}}'

secrets:
	kubectl create secret generic rails-environment --from-env-file=./production.env --dry-run=true -o yaml | kubectl apply -f -

service:
	kubectl apply -f ./service.yaml

deployment:
	kubectl apply -f ./deployment.yaml

ssh:
	kubectl exec -it $(POD) -c rails -- /bin/bash

console:
	kubectl exec -it $(POD) -c rails -- bundle exec rails console

info:
	kubectl cluster-info
	kubectl get services,deployments,rs,pods

rollout:
	kubectl patch deployment railsml-deployment -p $(ROLLOUT_PATCH)

rollback:
	kubectl rollout undo deployment/railsml-deployment
