#!/bin/bash
echo "Kyverno Values Generator Script"

NAME_OVERRIDE_VALUE=""
FULLNAME_OVERRIDE_VALUE=""
NAMESPACE_VALUE=""
TAG_VALUE=""
CHART_LOCATION="${BASH_SOURCE%/*}/../charts/kyverno/values.yaml"

print_usage(){
    echo "
    Kyverno Values Generator Script is used in generating dynamic templates of kyverno/charts/values.yaml
    
    Usage:
    -v = Name Override Value 
    -f = Fullname Override Value
    -n = Namespace Value
    -t  = initImage tag Value
    "
}

while getopts :v:f:n:t: flag; do
    case "${flag}" in
    v | --nameOverride) NAME_OVERRIDE_VALUE=${OPTARG} ;;
    f | --fullnameOverride) FULLNAME_OVERRIDE_VALUE=${OPTARG} ;;
    n | --namespace) NAMESPACE_VALUE=${OPTARG};;
    t | --tag)  TAG_VALUE=${OPTARG};;
    esac
done

if [ -z "${NAME_OVERRIDE_VALUE}" ] || [ -z "$FULLNAME_OVERRIDE_VALUE" ] || [ -z "${NAMESPACE_VALUE}" ] || [ -z "${TAG_VALUE}" ]; then
    print_usage
    exit 1
fi

echo "
The recieved variables are:

Name Override Value: ${NAME_OVERRIDE_VALUE} 
Fullname Override Value: ${FULLNAME_OVERRIDE_VALUE}
Namespace Value: ${NAMESPACE_VALUE}
Tag Value: ${TAG_VALUE}
"
echo "Generating values.yaml"

echo "
nameOverride: ${NAME_OVERRIDE_VALUE}
fullnameOverride: ${FULLNAME_OVERRIDE_VALUE}
namespace: ${NAMESPACE_VALUE}

image:
  repository: ghcr.io/kyverno/kyverno
  # Defaults to appVersion in Chart.yaml if omitted
  tag: ${TAG_VALUE}
  pullPolicy: IfNotPresent
  pullSecrets: []
  # - secretName
initImage:
  repository: ghcr.io/kyverno/kyvernopre
  # If initImage.tag is missing, defaults to image.tag
  tag:  ${TAG_VALUE}
" > $CHART_LOCATION
echo "Values generated"
