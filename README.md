# Terraform providers using AWS CloudFormation custom resources (BOA316)

This is an example how to use custom providers, a cloudformation feature, to let end-users all end-users use the same solution for custom resources.

Terraform, CDK and CloudFormation, support a lot of AWS cloud services. Sometimes, you want to automate something that is not supported by one or any of these frameworks. CloudFormation custom resources can help out. 

1. Custom Provider, contains alls scripts to deploy the custom provider (a Lambda function that can be used by others in CloudFormation)
2. Custom Resource, how to use that custom resource in CloudFormation
3. Terraform CloudFormation, how to use Terraform to Deploy a CloudFormation template (including the custom resource)
4. Terraform Module, get the files from the previous step and deploy this as a module in a public S3 bucket
5. Terraform Project, the final project where end-users easily use the module version 1.0
6. Upgrade Example, if we have a change in the Custom Provider, we will change the Module, and let users decide to upgrade to version 2.0 of the module and the provider

# Flow

## Prerequisites

An AWS Sandbox Account.

Deploy the application in **00-unicorn-tracker** using `terraform init && terraform apply`. 

Use the output (https address) as the UT_ENDPOINT / UnicornTrackerEndpoint in the next steps.

## 01 Deploy Custom Provider

First we deploy the Custom Provider. It's a lambda function that creates and deletes unicorns in the unicorn tracker.

```text
$ cd 01-custom-provider
$ S3_BUCKET=<some bucketname>
$ UT_ENDPOINT=<the endpoint of the previous step>
$ aws s3 mb s3://${S3_BUCKET}
$ aws cloudformation package \
    --template-file template.yml \
    --s3-bucket $S3_BUCKET > build.yml
$ aws cloudformation deploy \
    --stack-name ut-provider \
    --template build.yml \
    --parameter-overrides UnicornTrackerEndpoint=${UT_ENDPOINT} \
    --capabilities CAPABILITY_IAM
```

In case you do not export S3_BUCKET, the deploy script will ask to enter one. If the bucket does not exist yet, it will suggest to create one.

## 02 Custom Resource

Let's test our custom provider by deploying a custom resource. Because the previous step has a hardcoded function name, we are able to find it in your account.

```text
$ cd ../02-custom-resource
$ aws cloudformation deploy \
    --stack-name ut-cfn-resource \
    --template template.yml
```

## 03 Terraform + CloudFormation

Now it's time to do the same thing, but deploy the cloudformation stack from your terraform template.

```text
$ cd ../03-tf-cfn
$ terraform init
$ terraform apply
var.name
  Enter a name for the Unicorn

  Enter a value: <type a name for the unicorn>
...
$ terraform destroy
var.name
  Enter a name for the Unicorn

  Enter a value: <type a name for the unicorn>
```

## 04 Terraform Module

Let's publish this as a module to make it easier for our end users to use the custom provider.

```text
$ cd ../04-tf-module
$ terraform init
$ terraform apply
```

Do not destroy this stack yet, because we need it in the next step!

## 05 Terraform Project

Now the module is published, we can use it in our simplified project:

```text
$ cd ../05-tf-project
$ terraform init
$ terraform apply
$ terraform destroy
```

## Cleanup

After deleting the resource, wait some time before deleting the provider!

```text
$ cd ../04-tf-module
$ terraform destroy
$ aws cloudformation delete-stack \
    --stack-name ut-cfn-resource
$ aws cloudformation delete-stack \
    --stack-name ut-provider
```