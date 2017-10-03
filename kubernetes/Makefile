.PHONY: cloudsqlproxy rails ml secretfiles secrets ssh console info rollout rollback crons

ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[\
	{"name":"rails","image":"RAILSIMAGE"}\
	]}}}}'

cloudsqlproxy:
	kubectl apply -f cloudsqlproxy/deployment.yaml
	kubectl apply -f cloudsqlproxy/service.yaml

rails:
	kubectl apply -f rails/deployment.yaml
	kubectl apply -f rails/service.yaml
	kubectl apply -f rails/ingress.yaml

ml:
	kubectl apply -f ml/deployment.yaml
	kubectl apply -f ml/service.yaml

secretfiles:
	kubectl create secret generic cloudstorage-instance-credentials --from-file=credentials.json=../secrets/gcloudstorage.production.json
	kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=../secrets/gcloudsql.json

secrets:
	kubectl create secret generic rails-environment --from-env-file=rails/env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic ml-environment --from-env-file=ml/env --dry-run=true -o yaml | kubectl apply -f -

ssh:
	kubectl exec -it $(POD) -- /bin/bash

console:
	kubectl exec -it $(POD) -- bundle exec rails console

info:
	kubectl cluster-info
	kubectl get ingress,services,deployments,rs,pods,jobs -o wide

rollout:
	kubectl patch deployment rails-deployment -p \
		$(subst RAILSIMAGE,$(shell ./docker-repodigest rails),$(ROLLOUT_PATCH))

rollback:
	kubectl rollout undo deployment/rails-deployment

crons:
	kubectl apply -f ./crons/shakecam.yaml
