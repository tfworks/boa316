provider "aws" {}
provider "archive" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  s3_bucket = "ut-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "module_src/"
  output_path = "tfmodule.zip"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.s3_bucket
}

resource "aws_s3_object" "data_zip" {
  bucket = aws_s3_bucket.bucket.id
  key    = data.archive_file.lambda_zip.output_path
  acl    = "public-read"
  source = data.archive_file.lambda_zip.output_path
  etag   = data.archive_file.lambda_zip.output_md5
}

output "url" {
  value = "https://${aws_s3_bucket.bucket.bucket_domain_name}/${aws_s3_object.data_zip.key}"
}
