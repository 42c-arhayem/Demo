#!/bin/bash

# Prompt the user for the namespace
echo "Please enter the namespace:"
read namespace

# Define the API URLs
login_url="https://photo-demo.westeurope.cloudapp.azure.com/$namespace/api/user/login"
check_url="https://photo-demo.westeurope.cloudapp.azure.com/$namespace/api/admin/allusers"

# JSON data for the admin login
json_data_admin='{
    "user": "pixiadmin@demo.mail",
    "pass": "adminpixi"
}'

# Authenticate the admin user and extract the token
echo "Authenticating with the admin user..."
response=$(curl -s -X POST -H "Content-Type: application/json" -d "$json_data_admin" "$login_url")

# Extract the token
token=$(echo "$response" | jq -r '.token')

# Check if authentication was successful
if [ -z "$token" ] || [ "$token" == "null" ]; then
    echo "Authentication failed. Please check the admin credentials or the API endpoint."
    exit 1
else
    echo "Authentication successful."
fi

# Send a request to the /admin/allusers endpoint with the token
echo "Checking the API version..."
response=$(curl -s -X GET "$check_url" -H "x-access-token: $token" -H "Content-Type: application/json")

# Debug: Show the /admin/allusers response
echo "API version check response: $response"

# Check if the response contains the "password" parameter
if echo "$response" | grep -q '"password"'; then
    echo "The vulnerable API version is installed (password parameter is present)."
else
    echo "The patched API version is installed (password parameter is not present)."
fi