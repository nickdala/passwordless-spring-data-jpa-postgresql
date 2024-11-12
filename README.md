# passwordless-spring-data-jpa-postgresql

Sample project for Spring Data JPA with passwordless connection to Azure Database for PostgreSQL - Flexible Server via Service Connector

## Deploy

1. Log in to Azure
Before deploying, you must be authenticated to Azure and have the appropriate subscription selected. Run the following command to authenticate:

```
az login
```


If you have multiple tenants, you can use the following command to log into the tenant:

```shell
az login --tenant <tenant-id>
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


If you have multiple tenants, you can use the following command to log into the tenant:

```
azd auth login --tenant-id <tenant-id>
```

2. Create a new environment

Next we provide the AZD tool with variables that it uses to create the deployment. The first thing we initialize is the AZD environment with a name.

```
azd env new <pick_a_name>
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

The deployment process will output the URL of the deployed application.

```
Deploying services (azd deploy)

  (✓) Done: Deploying service application
  - Endpoint: https://app-nickdalasql.azurewebsites.net/


SUCCESS: Your application was deployed to Azure in 19 seconds.
```

>Note: The service connector script is located [here](https://github.com/nickdala/passwordless-spring-data-jpa-postgresql/blob/main/infra/scripts/setup-service-connector.sh).

>Note: The Terraform resouce that executes the script is [here](https://github.com/nickdala/passwordless-spring-data-jpa-postgresql/blob/main/infra/main.tf#L58).

## Test the application

The previous command will output the URL of the deployed application. You can use this URL to test the application.

```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Deploying services (azd deploy)

  (✓) Done: Deploying service application
  - Endpoint: https://app-nickpsql2.azurewebsites.net/
```

If you need to get the URL again, you can use the following command:

```
azd env get-value SERVICE_APPLICATION_ENDPOINTS
```

### Create a new Todo item

```
curl -X POST -H "Content-Type: application/json" -d '{"title":"Buy milk"}' <URL>/todos
```

### Get all Todo items

```
curl <URL>/todos
```

## Clean up

```
azd down --purge --force
```
