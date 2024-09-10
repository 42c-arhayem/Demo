#!/bin/bash

# Prompt the user for the namespace
echo "Please enter the namespace:"
read namespace
echo "Enter the intended state of the API:"
echo "1- Vulnerable & 2- Patched"
read api_state

# if helm status firewall-props >/dev/null 2>&1; then
#     echo "firewall-props is already installed."
# else
#     helm install firewall-props --debug ../artifacts/42c-firewall --namespace ali --set-string apifirewall.protection_token=d7cdec1f-9301-4042-b509-c6bb836504c4
# fi

if api_state == "1"; then
    helm upgrade  pixiapi --debug ../artifacts/42c-pixiapi --namespace $namespace --set pixiapp.inject_firewall=true --set pixiapp.pod_listen_port=8080 -f ../artifacts/42c-pixiapi/values-api.yaml
elif api_state == "2"; then
    helm upgrade  pixiapi --debug ../artifcats/42c-pixiapi --namespace $namespace --set pixiapp.inject_firewall=true --set pixiapp.pod_listen_port=8080 -f ../artifacts/42c-pixiapi/values-patched.yaml
else
    echo "Invalid choice."
    exit 1
fi