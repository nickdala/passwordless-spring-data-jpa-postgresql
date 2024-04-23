# passwordless-spring-data-jpa-postgresql

Sample project for Spring Data JPA with passwordless connection to Azure Database for PostgreSQL - Flexible Server via Service Connector

## Deploy

1. Log in to Azure
Before deploying, you must be authenticated to Azure and have the appropriate subscription selected. Run the following command to authenticate:

```
az login
```

Set the subscription to the one you want to use (you can use az account list to list available subscriptions):

```
export AZURE_SUBSCRIPTION_ID="<your-subscription-id>"
```

```
az account set --subscription $AZURE_SUBSCRIPTION_ID
```

Use the next command to login with the Azure Dev CLI (AZD) tool:

```
azd auth login
```

2. Create a new environment

Next we provide the AZD tool with variables that it uses to create the deployment. The first thing we initialize is the AZD environment with a name.

```
azd env new <pick_a_name>
```

Enable the AZD Terraform provider:

```
azd config set alpha.terraform on
```

Select the subscription that will be used for the deployment:

```
azd env set AZURE_SUBSCRIPTION_ID $AZURE_SUBSCRIPTION_ID
```

Set the Azure region to be used:

```
azd env set AZURE_LOCATION <pick_a_region>
```

3. Create the Azure resources and deploy the code

Run the following command to create the Azure resources and deploy the code (about 15-minutes to complete):

```
azd up
```