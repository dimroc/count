.PHONY: cloudsqlproxy rails ml secretfiles secrets staticip fixwebsockettimeout ssh
.PHONY: console info rollout rollback crons

ROLLOUT_PATCH = '{"spec":{"template":{"spec":{"containers":[{"name":"CONTNAME","image":"CONTSHA"}]}}}}'

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
	kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=../secrets/gcloudsql.json

secrets:
	kubectl create secret generic rails-environment --from-env-file=rails/env --dry-run=true -o yaml | kubectl apply -f -
	kubectl create secret generic ml-environment --from-env-file=ml/env --dry-run=true -o yaml | kubectl apply -f -

crons:
	kubectl apply -f ./crons/shakecam.yaml
	kubectl apply -f ./crons/dbtostorage.yaml

staticip:
	gcloud compute addresses create counting-company-production-ip --global

fixwebsockettimeout:
	# https://github.com/kubernetes/ingress/tree/master/controllers/gce/examples/websocket
	gcloud compute backend-services update $(BACKEND) --global --timeout=86400

ssh:
	kubectl exec -it $(POD) -- /bin/bash

console:
	kubectl exec -it $(POD) -- bundle exec rails console

info:
	kubectl cluster-info
	kubectl get ingress,services,deployments,rs,pods,jobs,cronjob -o wide

proxy:
	open 'http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy/#!/node?namespace=default'
	kubectl proxy

rollout:
	kubectl patch deployment rails-deployment -p \
		$(subst CONTSHA,$(shell ./docker-repodigest rails),$(subst CONTNAME,rails,$(ROLLOUT_PATCH)))
	kubectl patch deployment ml-deployment -p \
		$(subst CONTSHA,$(shell ./docker-repodigest ml),$(subst CONTNAME,mlv1,$(ROLLOUT_PATCH)))
	kubectl patch deployment ml-deployment -p \
		$(subst CONTSHA,$(shell ./docker-repodigest ml),$(subst CONTNAME,mlv2,$(ROLLOUT_PATCH)))

rollback:
	kubectl rollout undo deployment/rails-deployment

bootstrap-cluster: secretfiles secrets cloudsqlproxy rails ml crons info
