**Unicorn Tracker Infra setup**

This project sets up the AWS Infrastructure needed to run your Unicorn Tracker API.

Being rolled out : 
1. AWS Lambda (NodeJS)
2. DynamoDB Table
3. HTTP V2 API Gateway

To start rolling out run these commands : 

1. `export AWS_PROFILE=<profilename>` to set the right AWS Credentials to be used
2. `export AWS_REGION=<region-name>` to set the AWS region you want to use
3. `terraform init`
4. `terraform plan` to check what will be created
5. `terraform apply` to setup the environment

After this the infrastructure is ready to be used. Please write down the `api_gateway_url` output from Terraform.

If you are done with the challange, we advise you to cleanup the entire environment by running `terraform destroy`

***

**API Urls**

*Create unicorn*

`curl -X "PUT" -H "Content-Type: application/json" -d "{\"name\": \"My Unicorn\", \"length\": 180}" <api_gateway_url>/items`

This creates a Unicorn with the name `My Unicorn` with a length of 180 centimers.

*Get all unicorns*

`curl -v <api_gateway_url>/items`

*Get a specific unicorn by ID*

`curl -v <api_gateway_url>/items/<id>`

*Delete a unicorn*

`curl -v -X "DELETE" <api_gateway_url>/items/<id>`

