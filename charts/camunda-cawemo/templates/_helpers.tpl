{{/*
Expand the name of the chart.
*/}}
{{- define "camunda-cawemo.name" -}}
{{- default .Chart.Name .Values.general.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "camunda-cawemo.fullname" -}}
{{- if .Values.general.fullnameOverride }}
{{- .Values.general.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.general.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "camunda-cawemo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "camunda-cawemo.labels" -}}
helm.sh/chart: {{ include "camunda-cawemo.chart" . }}
{{ include "camunda-cawemo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Deployment Specific labels
*/}}
{{- define "camunda-cawemo-iam-frontend.labels" -}}
{{ include "camunda-cawemo-iam-frontend.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-iam-backend.labels" -}}
{{ include "camunda-cawemo-iam-backend.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-iam-router.labels" -}}
{{ include "camunda-cawemo-iam-router.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-garufa.labels" -}}
{{ include "camunda-cawemo-garufa.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-restapi.labels" -}}
{{ include "camunda-cawemo-restapi.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-adminer.labels" -}}
{{ include "camunda-cawemo-adminer.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-smtp.labels" -}}
{{ include "camunda-cawemo-smtp.selectorLabels" . }}
{{- end }}

{{- define "camunda-cawemo-webapp.labels" -}}
{{ include "camunda-cawemo-webapp.selectorLabels" . }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "camunda-cawemo.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Adminer Selector labels
*/}}
{{- define "camunda-cawemo-adminer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.adminer.containerName }}
{{- end }}

{{/*
SMTP Selector labels
*/}}
{{- define "camunda-cawemo-smtp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.smtp.containerName }}
{{- end }}

{{/*
IAM Front-End Selector labels
*/}}
{{- define "camunda-cawemo-iam-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.iam.frontend.containerName }}
{{- end }}

{{/*
IAM Back-End Selector labels
*/}}
{{- define "camunda-cawemo-iam-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.iam.backend.containerName }}
{{- end }}

{{/*
IAM Router Selector labels
*/}}
{{- define "camunda-cawemo-iam-router.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.iam.router.containerName }}
{{- end }}

{{/*
Garufa Selector labels
*/}}
{{- define "camunda-cawemo-garufa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.garufa.containerName }}
{{- end }}

{{/*
Garufa Selector labels
*/}}
{{- define "camunda-cawemo-restapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.restapi.containerName }}
{{- end }}

{{/*
Garufa Selector labels
*/}}
{{- define "camunda-cawemo-webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "camunda-cawemo.name" . }}-{{ .Values.webapp.containerName }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "camunda-cawemo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "camunda-cawemo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}