#pass env=full-stack
#pass env=dev
env ?= full-stack
chartValues ?= "./profile/$(env)-values.yaml"
#chartValues ?= "./development/camunda-values.yaml"
repository ?= https://helm.cch.camunda.cloud
repositoryName ?= camunda7

# Cawemo components will be installed into the following Kubernetes namespace
namespace ?= cawemo
# Helm release name
release ?= demo
# Helm chart coordinates for cawemo
chart ?= ./charts/camunda-cawemo

# encryption params
# Service to apply cert
service ?= serivce-name
# TLS secret name
secret_name ?= tls-secret
# Cert Signing Reqest (CSR) signer name
signerName ?= example.com\/pdiddy
# letsencrypt
certEmail ?= YOUR_EMAIL@camunda.com

#cloud params
region ?= eastus
clusterName ?= MY_CLUSTER_NAME
resourceGroup ?= MY_CLUSTER_NAME-rg
# This dnsLabel value will be used like so: MY_DOMAIN_NAME.region.cloudapp.azure.com
dnsLabel ?= MY_DOMAIN_NAME
machineType ?= Standard_A8_v2
minSize ?= 1
maxSize ?= 6
fqdn ?= ${dnsLabel}.${region}.cloudapp.azure.com

# Database params
dbNamespace ?= postgres
dbRelease ?= cawemo
iamdbRelease ?= iam
dbSecretName ?= database-credentials
dbName ?= workflow
dbUserName ?= workflow
dbPassword ?= workflow

# Pull Secret
pullSecretName ?= registry-credentials
dockerServer ?= registry.camunda.cloud
dockerUsername ?= paul.lungu
dockerPassword ?= poft3mal\!tair_CLOG
dockerEmail ?= paul.lungu@camunda.com

# license secret
licenseSecretName ?= license

.PHONY: kind
kind: kube \
namespace \
postgres \
ingress-nginx-kind \
# install

.PHONY: namespace
namespace:
	-kubectl create namespace $(namespace)
	-kubectl config set-context --current --namespace=$(namespace)

.PHONY: ingress-nginx-kind
ingress-nginx-kind:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

.PHONY: create-image-pull-secret
create-image-pull-secret:
	kubectl create secret docker-registry $(pullSecretName) --docker-server=$(dockerServer) --docker-username=$(dockerUsername) --docker-password=$(dockerPassword) --docker-email=$(dockerEmail) -n $(namespace)
	-kubectl get secret $(pullSecretName) --output=yaml -n $(namespace)

.PHONY: create-license-secret
create-license-secret:
	# kubectl create secret generic $(licenseSecretName) --from-file=./license.txt -n $(namespace)
	-kubectl get secret $(licenseSecretName) -o yaml -n $(namespace)

.PHONY: create-db-secret
create-db-secret:
	-kubectl create secret generic \
    $(dbSecretName) \
    --from-literal=DB_USERNAME=$(dbUserName) \
    --from-literal=DB_PASSWORD=$(dbPassword) \
		--namespace $(namespace)

.PHONY: install
install: namespace create-db-secret create-image-pull-secret create-license-secret
	@echo "Attempting to install Cawemo using chartValues: $(chartValues)"
	# -helm dependency build
	-helm repo add $(repositoryName) $(repository)
	-helm repo update $(repositoryName)
	-helm search repo $(chart)
	helm install --namespace $(namespace) $(release) $(chart) -f $(chartValues) --skip-crds --debug

.PHONY: clean-install
clean-install:
	-kubectl delete -n $(namespace) pvc -l app.kubernetes.io/instance=$(release)
	-kubectl delete -n $(namespace) pvc -l app=elasticsearch-master
	-kubectl delete namespace $(namespace)
	-helm --namespace $(namespace) uninstall $(release)

.PHONY: clean-ingress
clean-ingress:
	-helm --namespace ingress-nginx uninstall ingress-nginx
	-kubectl delete -n ingress-nginx pvc -l app.kubernetes.io/instance=ingress-nginx
	-kubectl delete namespace ingress-nginx

.PHONY: clean-database
clean-database: clean-postgres

.PHONY: clean
clean: clean-kube

include ./profile/kind/kubernetes-kind.mk
include ./profile/postgres/postgres.mk
