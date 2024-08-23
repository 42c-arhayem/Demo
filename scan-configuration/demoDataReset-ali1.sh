#!/bin/bash

# Run kubectl get pods command and store the output in a variable
kubectl_output=$(kubectl get pods -n ali1)

# Check if the kubectl command was successful
if [ $? -eq 0 ]; then
    # Extract the pod names containing "pixidb" from the output using grep
    pod_names=$(echo "$kubectl_output" | grep "pixidb" | awk '{print $1}')

    # Check if any pod names were extracted
    if [ -n "$pod_names" ]; then
        echo "The pods containing 'pixidb' in their names are:"
        echo "$pod_names"

        # Delete each of the pods containing "pixidb"
        for pod_name in $pod_names; do
            kubectl delete pod "$pod_name" -n ali1
            if [ $? -eq 0 ]; then
                echo "Deleted pod: $pod_name"
            else
                echo "Error: Failed to delete pod: $pod_name"
            fi
        done

        # Wait for a few seconds to allow the new pod to be created
        sleep 10

        # Get the name of the newly created pod containing "pixidb"
        new_pod_name=$(kubectl get pods -n ali1| grep "pixidb" | awk '{print $1}' | head -n 1)

        if [ -n "$new_pod_name" ]; then
            echo "New pod name: $new_pod_name"

            # JSON data for the API request 
            json_data_user_inbound='{"user": "user-inbound@acme.com","pass": "hellopixi","name": "User Inbound","is_admin": false,"account_balance": 1000}'
            json_data_user_common='{"user": "userscan-run@acme.com","pass": "hellopixi","name": "User Common","is_admin": false,"account_balance": 1000}'

            # Invoke the API using curl with POST method and passing the JSON data
            api_url="https://photo-demo.westeurope.cloudapp.azure.com/ali1/api/user/register"
            curl_response_inbound=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_data_user_inbound" "$api_url")
            curl_response_common=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_data_user_common" "$api_url")

            # Check the curl response
            if [ $? -eq 0 ]; then
                echo "API Response:"
                echo "Inbound user: $curl_response_inbound"
                echo "Common User: $curl_response_common"

                # Extract the token from the JSON response using jq
             #   token=$(echo "$curl_response_common" | jq -r '.token')

             #   if [ -n "$token" ]; then
             #       echo "Token to use as parameter SCAN42C_SECURITY_COMMON_ACCESS_TOKEN : $token"
             #       export PIXI_TOKEN="$token"
             #   else
             #       echo "Error: Failed to extract token from API response."
             #   fi

            else
                echo "Error: Failed to invoke the API."
            fi
        else
            echo "No new pod found containing 'pixidb' in its name."
        fi
    else
        echo "No pods found containing 'pixidb' in their names."
    fi
else
    echo "Error: Unable to run kubectl command. Please make sure kubectl is installed and configured correctly."
fi
