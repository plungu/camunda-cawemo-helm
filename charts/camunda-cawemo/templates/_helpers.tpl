{{/*
Expand the name of the chart.
*/}}
{{- define "cawemo.name" -}}
{{- default .Chart.Name .Values.general.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
gdfgdfg
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cawemo.fullname" -}}
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
{{- define "cawemo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cawemo.labels" -}}
helm.sh/chart: {{ include "cawemo.chart" . }}
{{ include "cawemo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Deployment Specific labels
*/}}
{{- define "iam-frontend.labels" -}}
{{ include "iam-frontend.selectorLabels" . }}
{{- end }}

{{- define "iam-backend.labels" -}}
{{ include "iam-backend.selectorLabels" . }}
{{- end }}

{{- define "iam-router.labels" -}}
{{ include "iam-router.selectorLabels" . }}
{{- end }}

{{- define "websockets.labels" -}}
{{ include "websockets.selectorLabels" . }}
{{- end }}

{{- define "restapi.labels" -}}
{{ include "restapi.selectorLabels" . }}
{{- end }}

{{- define "adminer.labels" -}}
{{ include "adminer.selectorLabels" . }}
{{- end }}

{{- define "smtp.labels" -}}
{{ include "smtp.selectorLabels" . }}
{{- end }}

{{- define "webapp.labels" -}}
{{ include "webapp.selectorLabels" . }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "cawemo.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Adminer Selector labels
*/}}
{{- define "adminer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.adminer.containerName }}
{{- end }}

{{/*
SMTP Selector labels
*/}}
{{- define "smtp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.smtp.containerName }}
{{- end }}

{{/*
IAM Front-End Selector labels
*/}}
{{- define "iam-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.iam.frontend.containerName }}
{{- end }}

{{/*
IAM Back-End Selector labels
*/}}
{{- define "iam-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.iam.backend.containerName }}
{{- end }}

{{/*
IAM Router Selector labels
*/}}
{{- define "iam-router.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.iam.router.containerName }}
{{- end }}

{{/*
Websockets Selector labels
*/}}
{{- define "websockets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.websockets.containerName }}
{{- end }}

{{/*
Websockets Selector labels
*/}}
{{- define "restapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.restapi.containerName }}
{{- end }}

{{/*
Websockets Selector labels
*/}}
{{- define "webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cawemo.name" . }}-{{ .Values.webapp.containerName }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cawemo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cawemo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress according to Kubernetes version.
*/}}
{{- define "cawemo.ingress.apiVersion" -}}
{{- if .Values.webapp.ingress.enabled -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.Version -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.Version -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end }}
{{- end }}
{{- end }}
