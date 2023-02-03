.PHONY: postgres
postgres: db-namespace install-postgres install-iam-postgres

.PHONY: db-namespace
db-namespace:
	-kubectl create namespace $(dbNamespace)
	# -kubectl config set-context --current --namespace=$(namespace)

.PHONY: install-postgres
install-postgres:
	-helm repo add bitnami https://charts.bitnami.com/bitnami
	-helm repo update bitnami
	helm --namespace $(dbNamespace) install $(dbRelease) \
	--set global.postgresql.auth.username=$(dbUserName),global.postgresql.auth.password=$(dbPassword),global.postgresql.auth.database=$(dbName) \
		bitnami/postgresql

.PHONY: install-iam-postgres
install-iam-postgres:
	-helm repo add bitnami https://charts.bitnami.com/bitnami
	-helm repo update bitnami
	helm --namespace $(dbNamespace) install $(iamdbRelease) \
	--set global.postgresql.auth.username=$(dbUserName),global.postgresql.auth.password=$(dbPassword),global.postgresql.auth.database=$(dbName) \
		bitnami/postgresql

.PHONY: clean-postgres
clean-postgres:
	-helm --namespace $(dbNamespace) uninstall $(dbRelease)
	-kubectl delete -n $(dbNamespace) pvc -l app.kubernetes.io/instance=$(dbRelease)
	-kubectl delete namespace $(dbNamespace)
	-kubectl delete secret $(dbSecretName) -n $(namespace)
