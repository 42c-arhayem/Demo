# 42C Banking API

A set of banking API with security vulnerabilities exposed in its design and implementation. 

## Introduction ##
42C Banking API provides endpoints to simulated services for an online banking experience. A customer can register a new account, then log into their account and access services like make a payment or apply for a new credit card. 

The first phase of this project simulates a customer online banking experience. 

The second phase will add an additional set of API endpoints to simulate an OpenBanking experience, where third party providers may be granted access to a customers banking data. 

If you have any request, please [create an issue](https://github.com/anthony-42crunch/42c-bank/issues/new) and describe what you need.

## Overview of the API endpoints (v1) ##

- Register
  - Create a new customer online bank account.
- Login
  - Log in to the account and retrieve an access token.
- Accounts
  - Read and write services on the customers account.
- Balances
  - Read the customers current account balance.
- Payee
  - Add or remove a contact or a utility account (e.g. electricty) to the customers list of payees for bank transfers.
- Payment
  - Initiate an online bank transfer
- Transactions
  - Retrieve a history of payments
- Credit card application
  - Apply for new credit card, that can be collected or posted to the customers preferred address.

## Get started ## 
1. Clone this repository to your local machine
2. Ensure your container software (e.g. Docker Desktop) is up and running
3. Run the following command using docker compose to pull the 42C Banking images and run them as local containers.

```
docker-compose -f 42c-bank.yaml up
```

The API is exposed over HTTP (http://localhost:3000) and also HTTPS (https://localhost).

https://github.com/42c-presales/42c-bank/assets/145518227/173060fa-ea3c-49f4-85f3-9b0d85604ff1

## Project resources ## 

### OpenAPI definitions ###
Two OpenAPI files are provided. One will receive an Audit score of ~60/100 and is intended to showcase API Security Audit. The second will receive an Audit score of 100/100 and 0 issues, and is intended for use with API Conformance Scan. 

### Seeded user accounts ### 
The database provided has two prepared user accounts out of the box. You can use these immediately to login and test the banking services. 

**User 1 login**
```
email: janedoe@email.com
pan: 11111 
```

**User 2 login**
```
email: drogers@email.com
pan: 99999
```

### Postman assets ###
A postman collection and enviroment are also provided to interact and test the API endpoints.  
