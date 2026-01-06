#!/bin/bash

set -euo pipefail

if [ -n "${OIDC_CONFIGURATION_ID_PARAM:-}" ]; then
  CONF_ID=$(circleci env subst "${OIDC_CONFIGURATION_ID_PARAM}")
fi

if [ -z "${CONF_ID:-}" ]; then
  echo "Error: OIDC configuration ID is not set. Please configure ${OIDC_CONFIGURATION_ID_PARAM} environment variable."
  exit 1
fi

TOKEN=$(circleci run oidc get --claims '{"aud":"api://emulator.wtf"}')
RESPONSE=$(curl -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -H "Accept: text/plain" -d "{\"oidcConfigurationUuid\":\"$CONF_ID\", \"oidcToken\":\"$TOKEN\"}" https://api.emulator.wtf/auth/oidc)
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
EW_API_TOKEN=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" -ge 400 ]; then
  echo "$EW_API_TOKEN" >&2
  exit 1
fi

echo "export EW_API_TOKEN=$EW_API_TOKEN" >> "$BASH_ENV"
echo "EW_API_TOKEN configured successfully."