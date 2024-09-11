#!/bin/bash

# Prompt the user for the namespace
echo "Please enter the namespace:"
read namespace

# Prompt the user to choose which Helm chart to deploy based on descriptions
echo "Choose the Pixi state to deploy:"
echo "1. Deploy the vulnerable version"
echo "2. Deploy the patched version"
read -p "Enter your choice (1 or 2): " choice

# Define the base directory as the parent directory of the scripts folder
base_dir="$(dirname "$(pwd)")"

# Define the Helm chart path using the absolute path
helm_chart_dir="$base_dir/artifacts/42c-pixiapi"

# Verify the directory exists
if [ ! -d "$helm_chart_dir" ]; then
    echo "Error: Helm chart directory not found at $helm_chart_dir"
    exit 1
fi

if [ "$choice" == "1" ]; then
    helm_chart="$helm_chart_dir/values-api.yaml"
elif [ "$choice" == "2" ]; then
    helm_chart="$helm_chart_dir/values-patched.yaml"
else
    echo "Invalid choice."
    exit 1
fi

# Uninstall existing release if it exists
helm uninstall pixiapi --namespace "$namespace"

# Run the Helm install command and check if it was successful
helm install pixiapi "$helm_chart_dir" --namespace "$namespace" -f "$helm_chart" --debug
if [ $? -ne 0 ]; then
    echo "Helm installation failed. Exiting script."
    exit 1
fi

# Wait for a few seconds to ensure the deployment is completed
sleep 20

# JSON data for the API request 
json_data_user_inbound='{"user": "user-inbound@demo.mail","pass": "hellopixi","name": "User Inbound","is_admin": false,"account_balance": 1000}'
json_data_user_common='{"user": "userscan-run@demo.mail.com","pass": "hellopixi","name": "User Common","is_admin": false,"account_balance": 1000}'

# Invoke the API using curl with POST method and passing the JSON data
api_url="https://photo-demo.westeurope.cloudapp.azure.com/$namespace/api/user/register"
curl_response_inbound=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_data_user_inbound" "$api_url")
curl_response_common=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_data_user_common" "$api_url")


# Check the curl response
if [ $? -eq 0 ]; then
echo "Users registered successfully."

#     # Extract the token from the JSON response using jq
#     token=$(echo "$curl_response_common" | jq -r '.token')

#     if [ -n "$token" ]; then
#         echo "Token to use as parameter SCAN42C_SECURITY_COMMON_ACCESS_TOKEN : $token"
#         export PIXI_TOKEN="$token"
#     else
#         echo "Error: Failed to extract token from API response."
#     fi
else
    echo "Error: Failed to invoke the API."
fi