terraform {
  backend "s3" {
    bucket         = "octabyte-s3-bucket"
    key            = "terraform/staging/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "OctaByte-dynamoDB-table"
    encrypt        = true
  }
}
 